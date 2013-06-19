require 'spec_helper'
require 'postman'

describe Postman::Notification do
  before :all do
    @user = FactoryGirl.create(:user)
    @post = FactoryGirl.create(:post)
    @post.subscribe @user
    @post.track(action: :bar)
    Postman.deliver
  end
  
  context Postman::Mailer do
    it "should have unique reply-to address" do
      last_email.reply_to.should include Postman::Mailer.reply_to(@user.notifications.last)
    end
    # it "should receive push notification" do
    # end
    # 
    # it "should receive iOS notification" do
    # end
    # 
    # it "should receive Andtoid notification" do
    # end
    # 
    
  end
end