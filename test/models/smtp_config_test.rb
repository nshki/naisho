require "test_helper"

class SmtpConfigTest < ActiveSupport::TestCase
  test "valid object" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password"

    assert smtp_config.valid?
  end

  test "valid object with other provider" do
    smtp_config = SmtpConfig.new \
      provider: "other",
      host: "smtp.localhost",
      port: 587,
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

  test "invalid without host for other provider" do
    smtp_config = SmtpConfig.new \
      provider: "other",
      port: 587,
      username: "test_username",
      password: "test_password"

    assert smtp_config.invalid?
  end

  test "invalid without port for other provider" do
    smtp_config = SmtpConfig.new \
      provider: "other",
      host: "smtp.localhost",
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

  test "#address returns correct value for standard provider" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password",
      host: ""

    assert_equal "smtp.gmail.com", smtp_config.address
  end

  test "#address returns correct value for other provider" do
    smtp_config = SmtpConfig.new \
      provider: "other",
      host: "smtp.localhost",
      port: 123,
      username: "test_username",
      password: "test_password"

    assert_equal "smtp.localhost", smtp_config.address
  end

  test "#provider_port returns correct value for standard provider" do
    smtp_config = SmtpConfig.new \
      provider: "gmail",
      username: "test_username",
      password: "test_password",
      port: ""

    assert_equal 587, smtp_config.provider_port
  end

  test "#provider_port returns correct value for other provider" do
    smtp_config = SmtpConfig.new \
      provider: "other",
      host: "smtp.localhost",
      port: 123,
      username: "test_username",
      password: "test_password"

    assert_equal 123, smtp_config.provider_port
  end
end
