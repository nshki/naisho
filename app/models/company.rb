# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  category   :string           not null
#  email      :string           not null
#  name       :string           not null
#  website    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_category  (category)
#  index_companies_on_website   (website) UNIQUE
#
class Company < ApplicationRecord
  include CaliforniaDataBrokersRequestable
  include DataBrokersWatchRequestable
  include Sanitizable
  include EmailCorrectable # Important to be after `Sanitizable`

  CATEGORIES = {
    california_data_broker: "california_data_broker",
    data_brokers_watch: "data_brokers_watch"
  }.freeze

  validates :category, inclusion: {in: CATEGORIES.values}
  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :name, presence: true
  validates :website, presence: true, uniqueness: true

  # Generates a human-readable source from which this company was gathered.
  #
  # @return [String]
  def source
    humanized_category =
      {
        CATEGORIES[:california_data_broker] => "CPPA",
        CATEGORIES[:data_brokers_watch] => "DataBrokersWatch.org"
      }[category]

    I18n.t("models.company.source", source: humanized_category)
  end
end
