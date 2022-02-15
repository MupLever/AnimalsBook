require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @post = posts(:one)
    @post_second = posts(:two)
    @user = users(:one)
    @post_second.user = @user
    @post.user = @user
  end
  
  test "should new post empty by setup" do
    post = Post.new
    assert !post.save
  end

  test "should new post no empty by setup" do
    assert @post.save
    if @post.save
      assert @post.destroy
    end
  end
end
