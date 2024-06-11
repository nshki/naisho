class DeletionRequestFlowsTest < ActionDispatch::IntegrationTest
  test "able to deliver emails for a valid bulk deletion request" do
    # Creating an extra California data broker company separate from fixtures.
    Company.create! \
      category: "california_data_broker",
      email: "test-ca-broker-2@localhost",
      name: "Test CA Broker 2",
      website: "https://test-ca-broker-2.localhost"

    post \
      bulk_deletion_requests_path,
      params: {
        email_subject: "Test deletion request subject",
        email_body: "Test deletion request body",
        smtp_provider: "gmail",
        smtp_username: "test_username",
        smtp_password: "test_password"
      }

    # The first email should be delivered immediately to ensure SMTP configuration
    # is correct.
    assert_emails 1
    assert_enqueued_emails 1
    assert_redirected_to new_bulk_deletion_request_path
    assert_equal "Deletion requests being sent through your SMTP provider. Check your email outbox for confirmation.", flash[:notice]

    # The rest of the emails should be able to be delivered later.
    perform_enqueued_jobs
    assert_emails 2
  end

  # It's possible for multiple companies to have the same contact email address
  # whether it's because there are umbrella companies at play or something else.
  # We should prevent duplicate emails so we're not requesting multiple times.
  test "only one email per unique email address is sent" do
    # Creating an extra California data broker company separate from fixtures.
    Company.create! \
      category: "california_data_broker",
      email: "test-ca-broker-2@localhost",
      name: "Test CA Broker 2",
      website: "https://test-ca-broker-2.localhost"
    # Creating another California data broker company with the same email address.
    Company.create! \
      category: "california_data_broker",
      email: "test-ca-broker-2@localhost", # SAME
      name: "Test CA Broker 3",
      website: "https://test-ca-broker-3.localhost"

    post \
      bulk_deletion_requests_path,
      params: {
        email_subject: "Test deletion request subject",
        email_body: "Test deletion request body",
        smtp_provider: "gmail",
        smtp_username: "test_username",
        smtp_password: "test_password"
      }

    # The first email should be delivered immediately, and there should only be one
    # more queued email to ensure we deduplicated email addresses.
    assert_emails 1
    assert_enqueued_emails 1
  end

  test "sets alert flash for invalid requests" do
    post \
      bulk_deletion_requests_path,
      params: {
        email_subject: "Test deletion request subject",
        email_body: "Test deletion request body",
        smtp_provider: "invalid_provider", # INVALID
        smtp_username: "test_username",
        smtp_password: "test_password"
      }

    assert_equal ["Smtp config is missing or invalid"], flash[:alert]
  end

  test "sets alert flash for SMTP authentication errors" do
    bulk_deletion_request_mock = Mocktail.of_next BulkDeletionRequest
    Mocktail
      .stubs { bulk_deletion_request_mock.deliver_emails }
      .with { raise Net::SMTPAuthenticationError.new("test") }

    post \
      bulk_deletion_requests_path,
      params: {
        email_subject: "Test deletion request subject",
        email_body: "Test deletion request body",
        smtp_provider: "gmail",
        smtp_username: "test_username",
        smtp_password: "test_password"
      }

    assert_equal \
      "SMTP authentication failed. Please check your SMTP username and password.",
      flash[:alert]
  end
end
