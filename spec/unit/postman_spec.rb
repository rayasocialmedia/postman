require 'spec_helper'
require 'postman'

describe Postman do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
  
  it "processor should mark all trails processed" do
    @user = FactoryGirl.create(:user)
    @post = FactoryGirl.create(:post)
    @another_user = FactoryGirl.create(:user1)
    @post.subscribe @user
    @post.track(action: :foo)
    Postman.deliver
    Postman::Trail.find_all_by_status(Postman::Trail::UNPROCESSED).count.should eq 0
  end
end
