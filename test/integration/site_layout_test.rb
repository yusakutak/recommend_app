require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'survey/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", form_path
   assert_select "a[href=?]", new_user_registration_path   
    assert_select "a[href=?]", new_user_session_path        
    assert_select "a[href=?]", destroy_user_session_path 
  end
end