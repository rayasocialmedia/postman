require 'postman/models/redis/base'

module Postman
  class Trail < RedisModel::Base
    attr_accessor :originator, :object, :action, :timestamp, :status, :payload
    
    UNPROCESSED = 'unprocessed'
    PROCESSED = 'processed'
    DELIVERED = 'delivered'
    READ = 'read'
    
    def initialize(params)
      super
      instance_variable_set("@status", 0)
      instance_variable_set("@timestamp", Time.now.to_i)
      # instance_variable_set("@uuid", SecureRandom.uuid)
    end

    def self.find_all_by_status status
      list = []
      key = "trails:#{status}"
      ids = Postman::Redis.redis.smembers(Postman::Redis.key(key))
      ids.each do |id|
        list << Trail.find(id)
      end
      list
    end
    
    def save
      super
      Postman::Redis.redis.multi do
        # Add to unprocessed
        Postman::Redis.redis.sadd Postman::Redis.key("trails:unprocessed"), self.id
        Postman::Redis.redis.sadd Postman::Redis.key("#{self.object.class.to_s.downcase}:#{self.object.id}:trails"), self.id
        Postman::Redis.redis.sadd Postman::Redis.key("#{self.object.class.to_s.downcase}:#{self.object.id}:#{self.action}:trails"), self.id
      end
      self
    end
  end
end