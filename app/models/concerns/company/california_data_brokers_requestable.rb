module Company::CaliforniaDataBrokersRequestable
  extend ActiveSupport::Concern

  REGISTRY_CSV_URI = URI("https://cppa.ca.gov/data_broker_registry/registry.csv").freeze

  included do
    scope :california_data_brokers, -> { where(category: Company::CATEGORIES[:california_data_broker]) }
  end

  class_methods do
    # Attempts to fetch and update all registered California data brokers.
    #
    # CSV structure last verified: 2026-07-22. A single broker may list multiple websites
    # separated by semicolons, in which case each website is upserted as a separate company.
    #
    # @return [void]
    def update_california_data_brokers
      RemoteCsv.each_row(REGISTRY_CSV_URI, row_sep: "\r\n") do |row|
        websites = row["Data broker primary website:"].to_s.split(";").map(&:strip)
        name = row["Data broker name:"]
        email = row["Data broker primary contact email address:"]
        next if websites.blank? || name.blank? || email.blank?

        websites.each do |website|
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
end
