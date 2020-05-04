ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

#Gem::Specification.find_by_name('bundler').activate

require 'bundler/setup' # Set up gems listed in the Gemfile.
