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
      @post.destroy
      Postman.process
      @user.notifications.count.should eq 1
    end
  end
end
