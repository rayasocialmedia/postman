require 'spec_helper'
require 'postman'

describe Postman::ActiveRecord do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post) }
  let(:another_user) { FactoryGirl.create(:user1) }
  
  it "should extend ActiveRecord objects with .track() method" do
    post.should respond_to :track
  end
    
  it "should create Postman::Trail by calling .track() on ActiveRecord model instances" do
    old_count = Postman::Trail.all.count
    post.track(action: :create)
    Postman::Trail.all.count.should eq (old_count + 1)
  end
    
  it "should extend ActiveRecord objects with .subscribe() method" do
    post.should respond_to :subscribe
  end
    
  it "should create subscribers by calling .subscribe()" do
    post.subscribe(user)
    post.subscribe(another_user)
    post.subscribers.count.should eq 2
  end
    
  it "should extend ActiveRecord objects with .subscribers() method" do
    post.should respond_to :subscribers
  end
    
  it "should be able to remove subscribers" do
    post.subscribe(user)
    post.unsubscribe(user)
    post.subscribers.count.should eq 0
  end
end
