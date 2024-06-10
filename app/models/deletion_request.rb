# Unpersisted object representing a new personal information deletion request to
# a company.
class DeletionRequest
  include ActiveModel::API
  include ActiveModel::Attributes
  include Serializable

  TOKENS =
    {
      company_name: "{COMPANY NAME}",
      full_name: "[YOUR FULL NAME]",
      full_address: "[YOUR FULL ADDRESS]",
      email_addresses: "[YOUR EMAIL ADDRESS(ES)]",
      phone_numbers: "[YOUR PHONE NUMBER(S)]",
      signature_name: "[YOUR SIGNATURE NAME]"
    }.freeze

  attr_accessor :company
  attr_accessor :smtp_config
  attribute :email_subject, :string
  attribute :email_body, :string

  validates_with Validator

  # Gives the email body but with applicable tokens interpolated with relevant data.
  #
  # @return [String]
  def interpolated_email_body
    email_body.gsub(TOKENS[:company_name], company.name)
  end
end
