module Postman
  class Subscription < ActiveRecord::Base
    
    if Rails.version < '4'
      attr_accessible :object, :action, :subscriber
    end
  end
end