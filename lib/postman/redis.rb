require 'redis'

module Postman
  module Redis
    mattr_accessor :connection
    
    def self.key bucket
      "postman:#{bucket}"
    end

    def self.sequence key
      self.redis.hincrby(redis_key('sequences'), key, 1)
    end
    
    def self.find_trails_by_status status
      self.smembers "trails:#{status}"
    end
    
    def self.get key
      self.redis.get redis_key(key)
    end
    
    def self.sget key
      self.redis.smembers(redis_key(key))
    end
    
    def self.zget key
      self.parse_back(self.redis.zrange(redis_key(key), 0, -1))
    end
    
    def self.srem key, id
      redis.srem key, id
    end
      
    def self.zrem key, id
      redis.zrem key, id
    end
    
    def self.clean
      redis.keys("#{prefix}:*").each do |key|
        redis.del key
      end
    end
      
    def self.redis
      if @@connection.nil?
        if Postman.redis_params['redis://']
          @@connection = ::Redis.connect(:url => self.redis, :thread_safe => true)
        else
          redis_params, namespace = Postman.redis_params.split('/', 2)
          host, port, db = redis_params.split(':')

          @@connection = ::Redis.new(
            :host => host,
            :port => port,
            :db => db,
            :thread_safe => true
          )
        end
      end
      @@connection
    end
    
    private
    
    def self.prefix
      'postman'
    end
      
    def self.redis_key bucket
      "postman:#{bucket}"
    end
    
    def self.parse_back items
      list = []
      items.each do |item|
        list << JSON.parse(item, { symbolize_names: true })
      end
      list
    end
  end
end