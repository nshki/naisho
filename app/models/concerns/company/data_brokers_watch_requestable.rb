module Company::DataBrokersWatchRequestable
  require "net/http"

  extend ActiveSupport::Concern

  API_URI = URI("https://databrokerswatch.org/api/databrokers").freeze

  included do
    scope :data_brokers_watch, -> { where(category: Company::CATEGORIES[:data_brokers_watch]) }
  end

  class_methods do
    # Attempts to fetch and update all companies available via the DataBrokersWatch API.
    #
    # @return [void]
    def update_data_brokers_watch_companies
      response = Net::HTTP.get(API_URI)
      response_json = JSON.parse(response)
      companies = response_json.dig("DataBrokers")

      companies.each do |company|
        website = company.dig("Domain")
        name = company.dig("Company Name") || company.dig("Domain")
        emails = company.dig("Emails").split(";")
        email = most_likely_email(emails)
        next if website.blank? || name.blank? || email.blank?

        upsert_by_website \
          website: website,
          name: name,
          email: email,
          category: Company::CATEGORIES[:data_brokers_watch]
      rescue ActiveRecord::RecordNotUnique
      end
    end
  end
end
