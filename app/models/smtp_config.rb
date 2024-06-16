# Unpersisted object representing SMTP configuration.
class SmtpConfig
  include ActiveModel::API
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  include ProvidersSupportable

  attribute :provider, :string
  attribute :host, :string
  attribute :port, :integer
  attribute :username, :string
  attribute :password, :string

  validates :provider, inclusion: {in: PROVIDERS.keys.push(:other).map(&:to_s)}
  validates :host, :port, presence: true, if: -> { provider == "other" }
  validates :username, :password, presence: true

  # To support `ActiveModel::Serialization`.
  #
  # @return [Hash]
  def attributes
    {
      "provider" => nil,
      "host" => nil,
      "port" => nil,
      "username" => nil,
      "password" => nil
    }
  end
end
