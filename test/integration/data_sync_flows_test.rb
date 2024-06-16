require "test_helper"

class DataSyncFlowsTest < ActionDispatch::IntegrationTest
  test "CPPA data brokers syncable" do
    assert_equal 1, Company.count # We start off with one fixture

    Company.update_california_data_brokers

    assert Company.count > 1
    assert_equal 0, Company.where("name like ?", " %").count
    assert_equal 0, Company.where("name like ?", "% ").count
    assert_equal 0, Company.where("website like ?", "%www%").count
  end

  test "DataBrokersWatch.org companies syncable" do
    assert_equal 1, Company.count # We start off with one fixture

    Company.update_data_brokers_watch_companies

    assert Company.count > 1
    assert_equal 0, Company.where("name like ?", " %").count
    assert_equal 0, Company.where("name like ?", "% ").count
    assert_equal 0, Company.where("website like ?", "%www%").count

    # Checking that `EmailCorrectable` is working as expected.
    assert_equal "consumeradvo@acxiom.com", Company.find_by(website: "acxiom.com").email
    assert_equal "info@verisk.com", Company.find_by(website: "verisk.com").email
  end
end
