class CompaniesController < ApplicationController
  # @route GET /companies (companies)
  def index
    @companies = Company.all.order(:website)
    @last_updated_at = Company.maximum(:updated_at).to_fs(:long)
  end
end
