require "test_helper"

class DataSyncFlowsTest < ActionDispatch::IntegrationTest
  test "all companies syncable" do
    assert_equal 1, Company.count # We start off with one fixture

    Company.sync_all

    assert Company.count > 1
    assert_equal 0, Company.where("name like ?", " %").count
    assert_equal 0, Company.where("name like ?", "% ").count
    assert_equal 0, Company.where("website like ?", "%www%").count

    # Checking that `EmailCorrectable` is working as expected.
    assert_equal "consumeradvo@acxiom.com", Company.find_by(website: "acxiom.com").email
    assert_equal "info@verisk.com", Company.find_by(website: "verisk.com").email
  end
end
