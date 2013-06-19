require 'spec_helper'
require 'postman'

describe Postman::Subscription do
  context 'Subscriber' do
    before :all do
      @user = FactoryGirl.create(:user)
      @post = FactoryGirl.create(:post)
      @another_user = FactoryGirl.create(:user1)
    end
  
    it "should be notified if the object changed" do
      @post.subscribe @user
      @post.track(action: :foo)
      Postman.deliver
      @user.notifications.count.should eq 1
    end

    it "should not be notified if the change originator is the subscriber himself" do
      @another_post = FactoryGirl.create(:post1)
      @another_post.subscribe @another_user
      @another_post.track(action: :bar, originator: @another_user)
      Postman.deliver
      @another_user.notifications.count.should eq 0
    end
  
    it "should receive email notification to his email" do
      last_email.to.should include(@user.email)
    end
  
    it "should not be notified unless subscribed" do
      @post.subscribe @user
      @post.track(action: :create, originator: @post.user)
      Postman.deliver
      @third_user = FactoryGirl.create(:user2)
      @third_user.notifications.count.should eq 0
    end
  end
end
