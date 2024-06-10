# Unpersisted object representing SMTP configuration.
class SmtpConfig
  include ActiveModel::API
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  include ProvidersSupportable

  attribute :provider, :string
  attribute :username, :string
  attribute :password, :string

  validates :provider, inclusion: {in: PROVIDERS.keys.map(&:to_s)}
  validates :username, :password, presence: true

  # To support `ActiveModel::Serialization`.
  #
  # @return [Hash]
  def attributes
    {
      "provider" => nil,
      "username" => nil,
      "password" => nil
    }
  end
end
