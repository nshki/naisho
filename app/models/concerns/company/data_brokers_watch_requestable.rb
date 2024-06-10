module Company::DataBrokersWatchRequestable
  extend ActiveSupport::Concern

  API_URI = URI("https://databrokerswatch.org/api/databrokers").freeze

  included do
    scope :data_brokers_watch, -> { where(category: Company::CATEGORIES[:data_brokers_watch]) }
  end

  class_methods do
    def update_data_brokers_watch_companies
      response = Net::HTTP.get(API_URI)
      response_json = JSON.parse(response)
      companies = response_json.dig("DataBrokers")

      companies.each do |company|
        email = company.dig("Emails").split(";").first
        name = company.dig("Company Name") || company.dig("Domain")
        website = company.dig("Domain")
        next if email.blank? || name.blank? || website.blank?

        company = Company.find_or_initialize_by(email: email)
        company.update \
          category: Company::CATEGORIES[:data_brokers_watch],
          name: name,
          website: website
      rescue ActiveRecord::RecordNotUnique
      end
    end
  end
end
