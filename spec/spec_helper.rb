# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'capybara/rspec'
require 'factory_girl_rails'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


# FactoryGirl.find_definitions

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  # Adding Capybara
  # config.include Capybara::DSL, :example_group => { :file_path => /\bspec\/integration\// }
  
  # config.before(:each) do
  #   DatabaseCleaner.start
  # end
  
  # Cleanup after every run
  config.before :all do
    DatabaseCleaner.clean
    Postman::Redis.clean
  end
  
  config.include(MailerMacros)
  
end