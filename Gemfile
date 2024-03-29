source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
 gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
 gem 'bcrypt', '~> 3.1.7'
 gem 'active_model_serializers', '~> 0.10.0'
 gem 'jwt'
 gem 'simple_command'
 gem 'cancancan'
 gem 'oj'
 gem 'oj_mimic_json'
 gem 'mysql2',          '~> 0.3.18', :platform => :ruby
 gem 'thinking-sphinx', '~> 3.3.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
 gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'pg'

gem 'ancestry'
gem 'sidekiq'
gem 'saxerator', :git => 'git://github.com/soulcutter/saxerator.git'
gem 'will_paginate', '~> 3.1.0'
gem 'devise', github: 'plataformatec/devise'
gem 'erubis'
gem 'carrierwave'
gem 'russian'
gem 'mini_magick'
gem 'sinatra', :require => nil
gem "sidekiq-status"
gem 'foreman'
gem 'whenever', :require => false
gem 'slim'

group :development do
  gem 'capistrano', 		require: false
  gem 'capistrano-rails',	require: false
  gem 'capistrano-bundler',	require: false
  gem 'capistrano-rvm',		require: false
  gem 'capistrano3-puma',	require: false
end
