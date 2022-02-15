# frozen_string_literal: true

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @email = (0...5).map do
      ('a'..'z').to_a[rand(26)]
      end.join + '@gmail.com'
    @password = (0...30).map do
      ('a'..'z').to_a[rand(26)]
      end.join
    @nickname = 'R' + (0...7).map do
      ('a'..'z').to_a[rand(26)]
      end.join
  end

  test 'should post user' do
    assert_difference('User.count') do
      post "/en/users",
           params: { user: { email: @email, nickname: @nickname, password: @password,
                             password_confirmation: @password } }
    end
  end

  test 'should new post form' do
    user = User.create email: @email, nickname: @nickname, password: @password, password_confirmation: @password
    post '/session', params: { email: user.email, password: @password }
    assert_redirected_to root_path
    get new_post_path
    assert_response :success
    assert_select 'textarea[name="post[body]"]'
  end

  test 'should edit post form' do
    user = User.create email: @email, nickname: @nickname, password: @password, password_confirmation: @password
    post '/session', params: { email: user.email, password: @password }
    assert_redirected_to root_path
    body = Faker::Lorem.word + Faker::Lorem.word
    post = user.posts.build body: body
    assert post.save
    get edit_post_path(post)
    assert_response :success
    assert_select 'textarea[name="post[body]"]'
  end

  test 'should show post form' do
    user = User.create email: @email, nickname: @nickname, password: @password, password_confirmation: @password
    post '/session', params: { email: user.email, password: @password }
    assert_redirected_to root_path
    body = Faker::Lorem.word + Faker::Lorem.word
    post = user.posts.build body: body
    assert post.save
    get post_path(post)
    assert_response :success
  end

  test 'user with correct credentials will see the root' do
    user = User.create email: @email, nickname: @nickname, password: @password, password_confirmation: @password
    user_bad = User.new email: @email, nickname: @nickname, password: @password, password_confirmation: @password
    assert !user_bad.save
    post '/session', params: { email: user.email, password: @password }
    assert_redirected_to root_path
    body = Faker::Lorem.word + Faker::Lorem.word
    post = user.posts.build body: body
    assert post.save
    body += Faker::Lorem.word
    assert post.update body: body
    assert post.destroy
  end
    
  test 'user will see the root after signing up' do
    email = Faker::Lorem.word
    nickname = Faker::Lorem.word
    password = Faker::Lorem.word
    post users_url, params: { user: {email: email, nickname: nickname, password: password, password_confirmation: password }}
    assert_response :success, root_path
  end
end
