# Form that allows the user to request data deletion from various companies.
class RequesterFormComponent < ApplicationComponent
  # Constructor.
  #
  # @param bulk_deletion_request [BulkDeletionRequest, nil]
  #   Optional, for retaining submitted data
  # @param url [String] The URL to submit the form to
  # @param flash [ActionDispatch::Flash::FlashHash, nil] Flash, if any
  # @param regulation [Hash, nil] See `Region::REGULATIONS`
  # @return [RequesterFormComponent]
  def initialize(url:, bulk_deletion_request: nil, flash: nil, regulation: nil)
    @bulk_deletion_request = bulk_deletion_request
    @url = url
    @flash = flash
    @regulation = regulation
  end

  # Gives the email subject field's value.
  #
  # @return [String]
  def email_subject_value
    retained_value = @bulk_deletion_request&.params&.dig("email_subject")
    i18n_value = I18n.t("components.requester_form.email_subject_value")
    retained_value || i18n_value
  end

  # Gives the email body field's value.
  #
  # @return [String]
  def email_body_value
    retained_value = @bulk_deletion_request&.params&.dig("email_body")

    # Stripping the i18n value to avoid extra whitespace in a textarea.
    i18n_value = I18n
      .t(
        "components.requester_form.email_body_value",
        regulation_name: @regulation&.dig(:name),
        regulation_code: @regulation&.dig(:id)&.upcase,
        region: @regulation&.dig(:region)
      )
      .strip

    retained_value || i18n_value
  end

  # Gives an array of options for the SMTP provider dropdown.
  #
  # @return [Array<String, String>]
  def smtp_provider_options
    supported_provider_options =
      SmtpConfig::PROVIDERS.map { |key, value| [value[:label], key] }
    supported_provider_options << [I18n.t("components.requester_form.smtp_other_provider"), "other"]
  end

  # Gives the SMTP provider field's selected value.
  #
  # @return [String]
  def smtp_provider_selected
    retained_value = @bulk_deletion_request&.params&.dig("smtp_provider")
    first_provider = SmtpConfig::PROVIDERS.keys.first
    retained_value || first_provider
  end

  # Gives the SMTP host field's value, if any.
  #
  # @return [String, nil]
  def smtp_host_value
    @bulk_deletion_request&.params&.dig("smtp_host")
  end

  # Gives the SMTP port field's value, if any.
  #
  # @return [String, nil]
  def smtp_port_value
    @bulk_deletion_request&.params&.dig("smtp_port")
  end

  # Gives the SMTP provider field's value, if any.
  #
  # @return [String, nil]
  def smtp_username_value
    @bulk_deletion_request&.params&.dig("smtp_username")
  end

  # Determines if the flash should be rendered.
  #
  # @return [Boolean]
  def show_flash?
    @flash.present?
  end

  # Gives the flash message, if any.
  #
  # @return [String, nil]
  def flash_message
    @flash[:notice]
  end

  # Determines if the flash has errors.
  #
  # @return [Boolean]
  def errors?
    @flash[:alert].present? && @flash[:alert].is_a?(Array)
  end

  # Fetches errors from the flash.
  #
  # @return [Array<String>]
  def errors
    @flash[:alert]
  end

  # Gets a list of providers and links to their app password articles.
  #
  # @return [Array<Hash>]
  def providers
    SmtpConfig::PROVIDERS.map do |_key, value|
      value.slice(:label, :app_password_article_url)
    end
  end
end
