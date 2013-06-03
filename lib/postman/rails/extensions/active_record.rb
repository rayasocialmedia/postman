module Postman
  module Rails
    module Extensions
      module ActiveRecord
        def self.included(base)
          # base.extend ClassMethods
        end

        def notify object, action, timestamp, payload = nil
          Notification.create({
            user: self,
            action: action,
            payload: payload,
            object: self
          })
        end
        
        def notifications
          Notification.where(user: self, )
        end
        
        def track originator, options = {}
          Trail.create({
            originator: originator,
            action: options[:action],
            payload: options[:payload],
            object: self
          })
        end
        
        def subscribe user, action = nil
          Subscription.create({
            object: self,
            action: action,
            subscriber: user
          })
        end
        
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
          # 
          # to be called from notifable models
          
        end
      
      end
    end
  end
end