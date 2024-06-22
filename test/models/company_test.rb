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
require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  test "valid object" do
    company = Company.new \
      category: "california_data_broker",
      email: "test-company@localhost",
      name: "Test Company",
      website: "https://localhost"

    assert company.valid?
  end

  test "invalid without a valid category" do
    company = Company.new \
      category: "invalid_category",
      email: "test-company@localhost",
      name: "Test Company",
      website: "https://localhost"

    assert company.invalid?
  end

  test "invalid without a valid email" do
    company = Company.new \
      category: "california_data_broker",
      email: "invalid-email",
      name: "Test Company",
      website: "https://localhost"

    assert company.invalid?
  end

  test "invalid without a name" do
    company = Company.new \
      category: "california_data_broker",
      email: "test-company@localhost",
      website: "https://localhost"

    assert company.invalid?
  end

  test "invalid without a website" do
    company = Company.new \
      category: "california_data_broker",
      email: "test-company@localhost",
      name: "Test Company"

    assert company.invalid?
  end

  test "#domainify_website! strips www. from website" do
    company = Company.new \
      category: "california_data_broker",
      email: "test-company@localhost",
      name: "Test Company",
      website: "https://www.localhost"

    company.domainify_website!

    assert_equal "localhost", company.website
  end

  test ".upsert_by_website doesn't override category" do
    company = Company.create \
      category: "california_data_broker",
      email: "test-company@localhost",
      name: "Test Company",
      website: "https://localhost"

    Company.upsert_by_website \
      category: "data_brokers_watch",
      email: "test-company-updated-email@localhost",
      name: "Test Company with updated name",
      website: "https://localhost"

    assert_equal "california_data_broker", company.reload.category
    assert_equal "Test Company with updated name", company.name
    assert_equal "test-company-updated-email@localhost", company.email
  end

  test ".upsert_by_website successfully creates a new company" do
    assert_equal 1, Company.count # Account for fixture

    Company.upsert_by_website \
      category: "california_data_broker",
      email: "test-company@localhost",
      name: "Test Company",
      website: "https://localhost"

    assert_equal 2, Company.count
  end
end
