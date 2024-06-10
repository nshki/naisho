# Responsible for custom serialization and deserialization of `DeletionRequest` objects.
# Opted to write a custom class outside of ActiveJob's support for custom serializers
# to avoid messing with autoload config.
module DeletionRequest::Serializable
  extend ActiveSupport::Concern

  class_methods do
    # Deserializes the given serialized deletion request.
    #
    # @param hash [Hash]
    # @return [DeletionRequest]
    def deserialize(hash)
      DeletionRequest.new \
        company: Company.find_by(id: hash.dig("company", "id")),
        smtp_config: SmtpConfig.new(hash["smtp_config"]),
        email_subject: hash["email_subject"],
        email_body: hash["email_body"]
    end
  end

  # Serializes the deletion request.
  #
  # @return [Hash]
  def serialize
    {
      "company" => {"id" => company.id},
      "smtp_config" => smtp_config.serializable_hash,
      "email_subject" => email_subject,
      "email_body" => email_body
    }
  end
end
