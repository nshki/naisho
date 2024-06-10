class SmtpConfigTest < ActiveSupport::TestCase
  test "valid object" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    assert smtp_config.valid?
  end

  test "invalid without a valid provider" do
    smtp_config = SmtpConfig.new \
      provider: "invalid_provider",
      username: "test_username",
      password: "test_password"

    assert smtp_config.invalid?
  end

  test "invalid without username" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      password: "test_password"

    assert smtp_config.invalid?
  end

  test "invalid without password" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username"

    assert smtp_config.invalid?
  end

  test "#address" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    assert_equal "smtp.gmail.com", smtp_config.address
  end

  test "#port" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    assert_equal 587, smtp_config.port
  end
end
