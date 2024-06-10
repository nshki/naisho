class DeletionRequestTest < ActiveSupport::TestCase
  test "valid object" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "Test deletion request body"

    assert deletion_request.valid?
  end

  test "invalid without a valid company" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: Company.new,
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "Test deletion request body"

    assert deletion_request.invalid?
  end

  test "invalid without a valid SMTP config" do
    smtp_config = SmtpConfig.new \
      provider: "invalid_provider",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "Test deletion request body"

    assert deletion_request.invalid?
  end

  test "invalid without an email subject" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_body: "Test deletion request body"

    assert deletion_request.invalid?
  end

  test "invalid without an email body" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject"

    assert deletion_request.invalid?
  end

  test "invalid with full name token still remaining" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "[YOUR FULL NAME]"

    assert deletion_request.invalid?
  end

  test "invalid with full address token still remaining" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "[YOUR FULL ADDRESS]"

    assert deletion_request.invalid?
  end

  test "invalid with email addresses token still remaining" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "[YOUR EMAIL ADDRESS(ES)]"

    assert deletion_request.invalid?
  end

  test "invalid with phone numbers token still remaining" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "[YOUR PHONE NUMBER(S)]"

    assert deletion_request.invalid?
  end

  test "invalid with signature name token still remaining" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "[YOUR SIGNATURE NAME]"

    assert deletion_request.invalid?
  end

  test "#interpolated_email_body returns expected output" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    deletion_request = DeletionRequest.new \
      company: companies(:california_data_broker),
      smtp_config: smtp_config,
      email_subject: "Test deletion request subject",
      email_body: "Hello {COMPANY NAME}"

    assert_equal "Hello Test CA Broker", deletion_request.interpolated_email_body
  end
end
