module Company::CaliforniaDataBrokersRequestable
  require "net/http"
  require "csv"

  extend ActiveSupport::Concern

  REGISTRY_CSV_URI = URI("https://cppa.ca.gov/data_broker_registry/registry.csv").freeze

  included do
    scope :california_data_brokers, -> { where(category: Company::CATEGORIES[:california_data_broker]) }
  end

  class_methods do
    # Attempts to fetch and update all registered California data brokers.
    #
    # @return [void]
    def update_california_data_brokers
      registry_csv = Net::HTTP.get(REGISTRY_CSV_URI)

      CSV.parse(registry_csv, headers: true, row_sep: "\r\n") do |row|
        email = row["Business primary contact email address"]
        name = row["Business name"]
        website = row["Business primary website"]
        next if email.blank? || name.blank? || website.blank?

        company = Company.find_or_initialize_by(email: email)
        company.update \
          category: Company::CATEGORIES[:california_data_broker],
          name: name,
          website: website
      rescue ActiveRecord::RecordNotUnique
      end
    end
  end
end
