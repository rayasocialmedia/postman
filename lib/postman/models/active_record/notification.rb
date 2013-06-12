module Postman
  class Notification < ActiveRecord::Base
    
    if Rails.version < '4'
      attr_accessor :uuid, :user, :object, :action, :payload
    end
  end
end