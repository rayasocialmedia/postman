require 'postman/models/redis/base'

module Postman
  class Notification < RedisModel::Base
    attr_accessor :uuid, :user, :object, :action, :payload
    
    def send!
      # E-mail sending
      if user.respond_to? :email
        if user.email.present?
          Postman::Mailer.notify(self).deliver!
        end
      end
      # Push notifications
    end
    
    def push_android
      n = Rapns::Gcm::Notification.new
      n.app = Rapns::Gcm::App.find_by_name(Postman.android_app_name)
      n.registration_ids = ["..."]
      n.data = {:message => "hi mom!"}
      n.save!
    end
    
    def push_ios
      n = Rapns::Apns::Notification.new
      n.app = Rapns::Apns::App.find_by_name("ios_app")
      n.device_token = "..."
      n.alert = "hi mom!"
      n.attributes_for_device = {:foo => :bar}
      n.save!
    end
    
    def self.find_all_by_user user
      list = []
      key = "user:#{user.id}:notifications"
      ids = Postman::Redis.redis.zrange(Postman::Redis.key(key), 0, -1)
      ids.each do |id|
        list << Notification.find(id)
      end
      list
    end
    
    def self.where conditions
      if conditions[:object].present? && conditions[:object].respond_to?(:id)
        object = conditions[:object]
        if conditions[:subscriber].present? && conditions[:subscriber].respond_to?(:id)
          id = conditions[:subscriber].id
          self.find_all_by_object(object).each do |item|
            return item if item.subscriber.id == id
          end
        end
      end
    end
    
    def destroy
      super
      Postman::Redis.redis.zrem Postman::Redis.key("user:#{self.user.id}:notifications"), self.id
    end
    
    def save
      instance_variable_set("@uuid", SecureRandom.uuid)
      super
      Postman::Redis.redis.zadd Postman::Redis.key("user:#{self.user.id}:notifications"), self.id, self.id
      self
    end
  end
end