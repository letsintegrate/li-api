source 'https://rubygems.org'

# Core gems
gem 'rails',                            '4.2.6'

# Database
gem 'pg',                               '~> 0.18'

# Redis
gem 'redis-namespace',                  '~> 1.5', '>= 1.5.2'

# Server
gem 'puma',                             '~> 3.2.0'

# CORS
gem 'rack-cors',                        '~> 0.4.0'

# API Versioning
gem 'versionist',                       '~> 1.4.1'

# API error messages
gem 'rails_api_validation_errors',      '~> 1.0', '>= 1.0.1'

# Filtering
gem 'ransack',                          '~> 1.7'
gem 'postgres_ext',                     '~> 3.0'

# Globalization
gem 'globalize',                        '~> 5.0.0'

# Authentication / Authorization
gem 'pundit',                           '~> 1.0.1'
gem 'pundit_namespaces',                '~> 0.1.1'

# Order number generation
gem 'ar-tokens',                        '~> 0.0.6'

# Serialization
gem 'active_model_serializers',         github: 'rails-api/active_model_serializers'
gem 'active_model_serializers-jsonapi_embedded_records_deserializer', '0.1.1'

# Validations
gem 'email_validator',                  '~> 1.6'

# Automation
gem 'sidekiq',                          '~> 4.1', '>= 4.1.2'
gem 'sidekiq-scheduler',                '~> 2.0', '>= 2.0.6'
gem 'sinatra',                          :require => nil

# Bot detection
gem 'recaptcha',                        '~> 1.3'

###############################################
# Development dependencies
###############################################

group :development, :test do
  # Pry console
  gem 'pry',                            '~> 0.10.3'
  gem 'pry-rails',                      '~> 0.3.4'
  gem 'pry-stack_explorer',             '~> 0.4.9.2'
  gem 'pry-remote',                     '~> 0.1.8'

  # Console formatting
  gem 'awesome_print',                  '~> 1.6.1'

  # RSpec testing instead of Test::Unit
  gem 'rspec-rails',                    '~> 3.4.0'
  gem 'rspec-apib',                     github: 'spieker/rspec-apib'

  # Test factories and dummy data
  gem 'factory_girl_rails',             '~> 4.5.0'
  gem 'ffaker',                         '~> 2.1.0'

  # Time testing
  gem 'timecop',                        '~> 0.8.1'

  # Guard
  gem 'guard',                          '~> 2.13.0',  require: false
  gem 'guard-rspec',                    '~> 4.6.4',   require: false

  # Documentation
  gem 'apiaryio',                       require: false
end

###############################################
# Test dependencies
###############################################

group :test do
  # Active Model Serializer testing
  gem 'shoulda-matchers',               '~> 3.0.1', require: false

  # JSON testing
  gem 'json_spec',                      '~> 1.1.4'
end
