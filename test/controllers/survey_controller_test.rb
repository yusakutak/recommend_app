require "test_helper"

class SurveyControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Recommend App"
  end

  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end


  test "should get form" do
    get form_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
end
