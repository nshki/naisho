module SmtpConfig::ProvidersSupportable
  extend ActiveSupport::Concern

  PROVIDERS =
    {
      # @see https://support.google.com/a/answer/176600
      gmail: {
        label: "Gmail",
        address: "smtp.gmail.com",
        port: 587,
        authentication: :login,
        app_password_article_url: "https://support.google.com/accounts/answer/185833"
      },

      # @see https://support.microsoft.com/en-us/office/pop-imap-and-smtp-settings-for-outlook-com-d088b986-291d-42b8-9564-9c414e2aa040
      outlook: {
        label: "Outlook",
        address: "smtp-mail.outlook.com",
        port: 587,
        authentication: :login,
        app_password_article_url: "https://support.microsoft.com/en-us/account-billing/manage-app-passwords-for-two-step-verification-d6dc8c6d-4bf7-4851-ad95-6d07799387e9"
      },

      # @see https://proton.me/support/smtp-submission
      protonmail: {
        label: "Proton Mail",
        address: "smtp.protonmail.ch",
        port: 587,
        authentication: :plain,
        app_password_article_url: "https://proton.me/support/smtp-submission#setup"
      },

      # @see https://www.fastmail.help/hc/en-us/articles/1500000279921-IMAP-POP-and-SMTP#01H8Q4KWEZ2JK8YS0FP85FM0H7
      fastmail: {
        label: "Fastmail",
        address: "smtp.fastmail.com",
        port: 587,
        authentication: :login,
        app_password_article_url: "https://www.fastmail.help/hc/en-us/articles/360058752854-App-passwords"
      }
    }.freeze

  # Returns the address of the SMTP provider.
  #
  # @return [String]
  def address
    PROVIDERS.dig(provider.to_sym, :address)
  end

  # Returns the port of the SMTP provider.
  #
  # @return [Integer]
  def port
    PROVIDERS.dig(provider.to_sym, :port)
  end

  # Returns the authentication method of the SMTP provider.
  #
  # @return [Symbol]
  def authentication
    PROVIDERS.dig(provider.to_sym, :authentication)
  end
end
