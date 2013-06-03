module Postman
  module RedisModel
    class Base
      attr_accessor :id, :_stub
      
      def initialize(params)
        params.each do |key, value|
          instance_variable_set("@#{key}", value) unless value.nil?
        end
      end
      
      def self.create(params)
        self.new(params).save
      end
      
      def self.find id
        Marshal.load(Postman::Redis.redis.get("#{self.klass}:#{id}"))
      end
      
      def self.all
        Postman::Redis.redis.smembers "#{self.klass.pluralize}"
      end
      
      def save
        instance_variable_set("@id", Postman::Redis.sequence("#{self.klass}"))
        # FIXME: Setting @_stub to fix weird behavior with Marshal.load
        # replacing the last attribute from the object with
        # @new_record_before_save
        instance_variable_set("@_stub", false)
        Postman::Redis.redis.set "#{self.klass}:#{self.id}", Marshal.dump(self)
        Postman::Redis.redis.sadd "#{self.klass.pluralize}", self.id
      end
      
      def destroy
        Postman::Redis.redis.del "#{self.klass}:#{self.id}"
      end
      
      protected
      def klass
        self.class.to_s.downcase.gsub(/\:\:/, ':')
      end
      
      def self.klass
        self.ancestors.first.to_s.downcase.gsub(/\:\:/, ':')
      end

      def to_hash
        hash = {}
        self.instance_variables.each do |var|
          hash[var.to_s.delete("@")] = self.instance_variable_get(var).to_json
        end
        hash
      end
      
    end
  end
end