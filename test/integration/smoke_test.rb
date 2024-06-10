class SmokeTest < ActionDispatch::IntegrationTest
  test "home page" do
    get "/"

    assert_response :success
  end

  test "about page" do
    get "/about"

    assert_response :success
  end

  test "companies page" do
    get "/companies"

    assert_response :success
  end

  test "new bulk deletion request page" do
    get "/bulk_deletion_requests/new?regulation=ccpa"

    assert_response :success
  end

  test "new bulk deletion request page redirects without regulation" do
    get "/bulk_deletion_requests/new"

    assert_redirected_to "/"
  end
end
