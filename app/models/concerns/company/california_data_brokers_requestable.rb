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
        website = row["Business primary website"]
        name = row["Business name"]
        email = row["Business primary contact email address"]
        next if website.blank? || name.blank? || email.blank?

        upsert_by_website \
          website: website,
          name: name,
          email: email,
          category: Company::CATEGORIES[:california_data_broker]
      rescue ActiveRecord::RecordNotUnique
      end
    end
  end
end
