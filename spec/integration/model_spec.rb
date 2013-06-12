require 'spec_helper'
require 'postman'

describe 'ActiveRecord' do
  context 'Models' do
    before :all do
      @user = User.create(name: 'John Doe')
      @post = @user.posts.create(title: 'The Quick Brown Fox Jumps Over The Lazy Dog')
      @another_user = User.create(name: 'Jane Smith')
    end
    
    it "should be able to call .track on any object" do
      @post.should respond_to :track
    end
    
    it "should be able to call .subscribe on any object" do
      @post.should respond_to :subscribe
    end
    
    it "should be able to call .subscribers on any object" do
      @post.should respond_to :subscribers
    end
    
    it "should be able to add trails" do
      old_count = Postman::Trail.all.count
      @post.track(action: :create)
      Postman::Trail.all.count.should eq (old_count + 1)
    end
    
    it "should be able to add subscribers" do
      @post.subscribe(@user)
      @post.subscribe(@another_user)
      @post.subscribers.count.should eq 2
    end
    
    it "should be able to remove subscribers" do
      @post.unsubscribe(@user)
      @post.subscribers.count.should eq 1
    end
  end
end
