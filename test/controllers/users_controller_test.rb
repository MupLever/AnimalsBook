require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @email = (0...20).map do
      ('a'..'z').to_a[rand(26)]
      end.join
    @password = (0...20).map do
      ('a'..'z').to_a[rand(26)]
      end.join
    @nickname = (0...20).map do
      ('a'..'z').to_a[rand(26)]
      end.join
  end

  test "should get new view" do
    get new_user_url
    assert_response :success
    assert_select 'input[name="user[email]"]'
    assert_select 'input[name="user[nickname]"]'
    assert_select 'input[name="user[password]"]'
    assert_select 'input[name="user[password_confirmation]"]'
  end 

  test "should get edit view" do
    @user = User.create email: @email, nickname: @nickname, password: @password, password_confirmation: @password
    post '/ru/session', params: { email: @user.email, password: @password }
    assert_redirected_to '/ru'
    get edit_user_url(@user)
    assert_response :success
    assert_select 'input[name="user[email]"]'
    assert_select 'input[name="user[nickname]"]'
    assert_select 'input[name="user[password]"]'
    assert_select 'input[name="user[password_confirmation]"]'
  end 
end




