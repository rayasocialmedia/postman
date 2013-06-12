require 'spec_helper'
require 'postman'

describe Postman do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
  
  it "processor should mark all trails processed" do
    @user = User.create(name: 'John Doe')
    @post = @user.posts.create(title: 'The Quick Brown Fox Jumps Over The Lazy Dog')
    @post.subscribe @user
    @post.track(action: :foo)
    Postman.deliver
    Postman::Trail.find_all_by_status(Postman::Trail::UNPROCESSED).count.should eq 0
  end
end
