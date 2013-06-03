rails_root = Rails.root || File.dirname(__FILE__) + '/../..'
rails_env = Rails.env || 'development'

Postman.setup do |config|
  config.backend = :redis
  config.redis_params = YAML.load_file("#{ rails_root.to_s }/config/redis.yml")[Rails.env.to_s]
end