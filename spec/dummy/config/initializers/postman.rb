rails_root = Rails.root || File.dirname(__FILE__) + '/../..'
rails_env = Rails.env || 'development'

Postman.setup do |config|
  config.backend = :redis
  config.redis_params = YAML.load_file("#{ rails_root.to_s }/config/redis.yml")[Rails.env.to_s]
  # Use RAPNS gem for mobile pushing
  config.push_rapns_ios_app = 'foobar1'
  config.push_rapns_android_app = 'foobar2'
end