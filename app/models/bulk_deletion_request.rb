# Responsible for handling server requests to send out many deletion request emails.
class BulkDeletionRequest
  attr_reader :params, :errors

  # Constructor.
  #
  # @param params [ActionControler::Parameters]
  # @return [BulkDeletionRequest]
  def initialize(params = {})
    @params = params
    @serialized_deletion_requests = []
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
  # The first email is delivered synchronously so SMTP misconfiguration surfaces
  # immediately to the caller. If that send is throttled for hitting a send limit
  # (`Net::SMTPServerBusy`), it is rescheduled for later instead of failing the
  # request.
  #
  # @raise [Net::SMTPAuthenticationError] If SMTP authentication fails
  # @return [void]
  def deliver_emails
    @serialized_deletion_requests.each.with_index do |serialized_deletion_request, index|
      if index.zero?
        deliver_now_or_reschedule(serialized_deletion_request)
      else
        email_for(serialized_deletion_request).deliver_later
      end
    end
  end

  private

  # Delivers the given request synchronously, rescheduling it for later if the
  # provider throttles the send for hitting a limit.
  #
  # @param serialized_deletion_request [Hash]
  # @return [void]
  def deliver_now_or_reschedule(serialized_deletion_request)
    email_for(serialized_deletion_request).deliver_now
  rescue Net::SMTPServerBusy
    email_for(serialized_deletion_request).deliver_later
  end

  # Builds a fresh deletion request email for the given serialized request.
  #
  # @param serialized_deletion_request [Hash]
  # @return [ActionMailer::MessageDelivery]
  def email_for(serialized_deletion_request)
    DeletionRequestMailer.deletion_request(serialized_deletion_request)
  end

  # Generate a deletion request for each company, serialized for delivery.
  #
  # @return [void]
  def generate_emails
    Company.all.group(:email).find_each do |company|
      deletion_request = DeletionRequest.new \
        company: company,
        smtp_config: smtp_config,
        email_subject: @params[:email_subject],
        email_body: @params[:email_body]

      if deletion_request.invalid?
        @errors = deletion_request.errors.full_messages
        break
      end

      @serialized_deletion_requests << deletion_request.serialize
    end
  end

  # Construct a memoized SMTP configuration object from the given parameters.
  #
  # @return [SmtpConfig]
  def smtp_config
    @_smtp_config ||= SmtpConfig.new \
      provider: @params[:smtp_provider],
      host: @params[:smtp_host],
      port: @params[:smtp_port],
      username: @params[:smtp_username],
      password: @params[:smtp_password]
  end
end
