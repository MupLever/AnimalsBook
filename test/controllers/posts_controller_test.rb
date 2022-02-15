require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = users(:one)
    @post.user = @user
  end

  test "should get new view" do
    get "http://localhost:3000/ru/posts/new"
    assert_response :redirect
  end 

  test "should edit view" do
    if @post.save
      get "http://localhost:3000/ru/posts/#{@post.id}/edit"
      assert_response :redirect
      assert @post.destroy
    end
  end 

  test "should update post no empty data" do
    body = (0...20).map do
      ('a'..'z').to_a[rand(26)]
    end.join
    
    assert @post.save
    if @post.save
      patch "http://localhost:3000/ru/posts/#{@post.id}", params:{ post: {body: body}}
      assert_response :redirect
      assert @post.update body: body
      assert_redirected_to "http://localhost:3000/ru"
      assert @post.destroy
    end
  end
end
