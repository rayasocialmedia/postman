# -*- encoding: utf-8 -*-

require File.expand_path('../lib/postman/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "postman"
  gem.version       = Postman::VERSION
  gem.summary       = %q{Delivery Manager for Rails Applications}
  gem.description   = %q{Delivery Manager for Rails Applications}
  gem.license       = "MIT"
  gem.authors       = ["Omar Abdel-Wahab"]
  gem.email         = "owahab@gmail.com"
  gem.homepage      = "https://github.com/rayasocialmedia/postman"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency "rails", "~> 3.2.0"
  gem.add_dependency "redis"

  gem.add_development_dependency "sqlite3"
  # gem.add_development_dependency "rspec", "~> 2.4"
  gem.add_development_dependency "rubygems-tasks", "~> 0.2"
  gem.add_development_dependency "yard", "~> 0.8"
  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "factory_girl_rails"
  gem.add_development_dependency "database_cleaner"
  gem.add_development_dependency "capybara"
end
