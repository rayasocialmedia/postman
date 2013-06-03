require 'postman/models/redis/base'

module Postman
  class Subscription < RedisModel::Base
    attr_accessor :object, :action, :subscriber, :key
    
    def self.find_all_by_object object
      list = []
      key = "#{object.class.to_s.downcase}:#{object.id}:subscriptions"
      ids = Postman::Redis.redis.smembers(Postman::Redis.key(key))
      ids.each do |id|
        list << Subscription.find(id)
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
      Postman::Redis.redis.srem Postman::Redis.key("#{self.object.class.to_s.downcase}:#{self.object.id}:subscriptions"), self.id
    end
    
    def save
      super
      Postman::Redis.redis.sadd Postman::Redis.key("#{self.object.class.to_s.downcase}:#{self.object.id}:subscriptions"), self.id
      self
    end
  end
end