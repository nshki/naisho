# Renders a grid of companies.
class CompanyGridComponent < ApplicationComponent
  # Constructor.
  #
  # @param companies [Company::ActiveRecord_Relation]
  # @return [CompanyGridComponent]
  def initialize(companies:)
    @companies = companies
  end
end
