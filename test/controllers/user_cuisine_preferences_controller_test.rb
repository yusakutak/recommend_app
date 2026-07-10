require "test_helper"

class UserCuisinePreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get user_cuisine_preferences_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_cuisine_preferences_update_url
    assert_response :success
  end
end
