source 'https://rubygems.org'

gem 'coffee-rails'
gem 'jquery-ui-rails'
gem 'jquery-rails'
gem 'sqlite3'
gem 'rack-timeout'
gem 'rails', '4.1.1'
gem 'recipient_interceptor'
gem 'sass-rails', '~> 4.0.3'
gem 'simple_form', '3.1.0.rc2'
gem 'uglifier'
gem 'unicorn'
# Draper for decoration.
gem 'draper', '~> 1.3'
# Use bootstrap-sass for bootstrap assets
gem 'bootstrap-sass', '~> 3.1.1'
# CAS Client
gem 'rubycas-client', :git => 'git://github.com/terrellt/rubycas-client.git', :branch => 'master'
gem 'rubycas-client-rails', :git => 'git://github.com/osulp/rubycas-client-rails.git'
gem 'sidekiq'
#For photo uploaders
gem 'carrierwave'
gem 'rmagick', '~> 2.13.2', :require => false
#For datatables
gem 'jquery-datatables-rails', '~> 2.2.3'
#Tinimce for text editing
gem 'tinymce-rails', '4.0.11'
gem 'mysql2'
gem 'pundit'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'capistrano', '~> 2.0'
end

group :development, :test do
  gem 'awesome_print'
  gem 'jazz_hands', :github => "terrellt/jazz_hands"
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 2.14.0'
  # Test Coverage
  gem 'coveralls', :require => false
  gem 'simplecov'
end

group :test do
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'formulaic'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
  gem 'webmock'
end
