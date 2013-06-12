require 'postman/rails/extensions/active_record'
require 'rails'

module Postman
  module Rails
    class Engine < ::Rails::Engine
      config.generators do |g|
        g.test_framework      :rspec,        :fixture => false
        g.fixture_replacement :factory_girl, :dir => 'spec/factories'
        g.assets false
        g.helper false
      end
      initializer 'postman.initialize' do
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.send :include, Postman::Rails::Extensions::ActiveRecord
        end
      end
      initializer 'postman.models' do
        if Postman.backend == false
          raise Postman::PostmanInvalidBackend, 'No backend was specified, aborting...'
        elsif Postman.backend.to_sym == :redis
          if Postman.redis_params.nil?
            raise Postman::PostmanInvalidRedisParams, 'Redis Parameters missing from initializer'
          else
            require 'postman/models/redis/trail'
            require 'postman/models/redis/subscription'
            require 'postman/models/redis/notification'
          end
        elsif Postman.backend.to_sym == :activerecord
          require 'postman/models/active_record/trail'
          require 'postman/models/active_record/subscription'
          require 'postman/models/active_record/notification'
        else
          raise Postman::PostmanInvalidBackend, 'Unsupported backend specified'
        end
      end
      
    end
  end
end
