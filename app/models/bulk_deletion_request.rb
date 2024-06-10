# Responsible for handling server requests to send out many deletion request emails.
class BulkDeletionRequest
  attr_reader :params, :errors

  # Constructor.
  #
  # @param params [ActionControler::Parameters]
  # @return [BulkDeletionRequest]
  def initialize(params = {})
    @params = params
    @emails = []
    @errors = nil

    generate_emails
  end

  # Check if the bulk deletion request is valid.
  #
  # @return [Boolean]
  def valid?
    @errors.blank?
  end

  # Check if the bulk deletion request is invalid.
  #
  # @return [Boolean]
  def invalid?
    !valid?
  end

  # Send out all generated deletion request emails.
  #
  # @raise [Net::SMTPAuthenticationError] If SMTP authentication fails
  # @return [void]
  def deliver_emails
    @emails.each.with_index do |email, index|
      index.zero? ? email.deliver_now : email.deliver_later
    end
  end

  private

  # Generate a deletion request email for each California data brokers.
  #
  # @return [void]
  def generate_emails
    Company.california_data_brokers.find_each.with_index do |company, index|
      deletion_request = DeletionRequest.new \
        company: company,
        smtp_config: smtp_config,
        email_subject: @params[:email_subject],
        email_body: @params[:email_body]

      if deletion_request.invalid?
        @errors = deletion_request.errors.full_messages
        break
      end

      serialized_deletion_request = deletion_request.serialize
      @emails << DeletionRequestMailer.deletion_request(serialized_deletion_request)
    end
  end

  # Construct a memoized SMTP configuration object from the given parameters.
  #
  # @return [SmtpConfig]
  def smtp_config
    @_smtp_config ||= SmtpConfig.new \
      provider: @params[:smtp_provider],
      username: @params[:smtp_username],
      password: @params[:smtp_password]
  end
end
