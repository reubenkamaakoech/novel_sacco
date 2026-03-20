require "test_helper"

class AppConfigsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get app_configs_edit_url
    assert_response :success
  end

  test "should get update" do
    get app_configs_update_url
    assert_response :success
  end
end
