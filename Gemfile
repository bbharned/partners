source 'https://rubygems.org'
ruby '3.0.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'

gem "activerecord", ">= 5.2.4.5"
gem 'bootstrap', '~> 4.3.1'

gem 'will_paginate', '~> 3.1', '>=3.1.5'
gem 'bootstrap-will_paginate', '1.0.0'

gem 'bootstrap-datepicker-rails'

gem 'aws-sdk-s3', '~> 1.96', '>= 1.96.1', require: false

gem "rqrcode", "~> 2.0"

# Use Puma as the app server
gem "puma", ">= 5.6.4"
# Use SCSS for stylesheets
#gem 'sass-rails', '~> 5.0'
#gem 'sassc-rails'
gem 'sassc'
gem "nokogiri", ">= 1.13.10"
gem "rack", ">= 2.2.3.1"
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# gem 'webpacker', '~> 5.0'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem "loofah", ">= 2.19.1"

gem 'mimemagic', '~> 0.3.10'

gem 'filterrific', '~> 5.2', '>= 5.2.2'
gem 'icalendar', '~> 2.3'
gem 'geocoder', '~> 1.7', '>= 1.7.5'

gem 'rails-html-sanitizer', '~> 1.4.4'

gem 'net-http'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false


group :development, :test do
  gem 'sqlite3', '~> 1.4'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do #configured for Heroku
  gem 'pg'
  #gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
