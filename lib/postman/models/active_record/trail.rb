module Postman
  class Trail < ActiveRecord::Base
    
    UNPROCESSED = 0
    PROCESSED = 1
    DELIVERED = 2
    READ = 4
    
    def before_create
      if self.id.nil?
        self.uuid = SecureRandom.uuid
      end
    end
    
    if Rails.version < '4'
      attr_accessible :originator, :object, :action, :timestamp, :status, :payload
    end
  end
end