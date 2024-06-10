class DeletionRequestMailer < ApplicationMailer
  # Personal information deletion request email generated from a given `DeletionRequest`.
  #
  # @param serialized_deletion_request [Hash]
  # @return [Mail::Message]
  def deletion_request(serialized_deletion_request)
    @deletion_request = DeletionRequest.deserialize(serialized_deletion_request)

    delivery_options = {
      user_name: @deletion_request.smtp_config.username,
      password: @deletion_request.smtp_config.password,
      address: @deletion_request.smtp_config.address,
      port: @deletion_request.smtp_config.port,
      authentication: :login
    }

    mail \
      from: @deletion_request.smtp_config.username,
      to: @deletion_request.company.email,
      subject: @deletion_request.email_subject,
      delivery_method_options: delivery_options
  end
end
