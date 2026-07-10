require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get mypage" do
    get pages_mypage_url
    assert_response :success
  end
end
