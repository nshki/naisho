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
    assert_redirected_to root_path
    assert_equal "Deletion requests being sent through your SMTP provider. Check your email outbox for confirmation.", flash[:notice]

    # The rest of the emails should be able to be delivered later.
    perform_enqueued_jobs
    assert_emails 2
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
end
