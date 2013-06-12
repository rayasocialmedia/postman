require 'spec_helper'
require 'postman'

describe 'Subscribers' do
  context 'to an object' do
    before :all do
      @user = User.create(name: 'John Doe')
      @post = @user.posts.create(title: 'The Quick Brown Fox Jumps Over The Lazy Dog')
      @another_user = User.create(name: 'Jane Smith')
    end
    
    it "should be notified if the object changed" do
      @post.subscribe @user
      @post.track(action: :foo)
      Postman.deliver
      @user.notifications.count.should eq 1
    end

    it "should not be notified if the change originator is the subscriber himself" do
      @another_post = @user.posts.create(title: 'The Quick Brown Fox Jumps Over The Lazy Dog')
      @another_post.subscribe @another_user
      @another_post.track(action: :bar, originator: @another_user)
      Postman.deliver
      @another_user.notifications.count.should eq 0
    end

    # it "to other objects will not be notified" do
    #   @post.subscribe @user
    #   @post.track(action: :create, originator: @post.user)
    #   Postman.deliver
    #   @third_user = User.create(name: 'Jane Doe')
    #   @third_user.notifications.count.should eq 0
    # end
  end
end
