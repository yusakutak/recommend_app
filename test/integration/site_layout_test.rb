require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links as guest" do
    get root_path
    assert_template "survey/home"
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", form_path
    assert_select "a[href=?]", new_user_registration_path
    assert_select "a[href=?]", new_user_session_path
  end

  test "layout links as signed in user" do
    sign_in users(:one)
    get root_path
    assert_template "survey/home"
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", form_path
    assert_select "a[href=?]", mypage_path
  end
end
