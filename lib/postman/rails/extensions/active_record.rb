module Postman
  module Rails
    module Extensions
      module ActiveRecord
        def self.included(base)
          # base.extend ClassMethods
        end
        
        # Notify an object, usually a user, with a change on an object
        def notify object, action, timestamp, payload = nil
          Notification.create({
            user: self,
            action: action,
            payload: payload,
            object: object
          })
        end
        
        # Retriece notifications for a specific object, usually a user
        def notifications
          Notification.find_all_by_user(self)
        end
        
        # Track an action on current object
        def track options = {}
          Trail.create({
            originator: options[:originator],
            action: options[:action],
            payload: options[:payload],
            object: self
          })
        end
        
        # Subscribe a user to current object
        def subscribe user, action = nil
          Subscription.create({
            object: self,
            action: action,
            subscriber: user
          })
        end
        
        # TODO: Allow unsubscribing from specific actions
        def unsubscribe user
          Subscription.where(subscriber: user, object: self).destroy
        end
        
        def subscribers
          Subscription.find_all_by_object(self)
        end

        module ClassMethods
          # # to be called from user model
          # def acts_as_notifiable options = {}
          #   require "postman/rails/models/notifiable"
          #   include Postman::Rails::Models::Notifiable
          # end
        end
      end
    end
  end
end