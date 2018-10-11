# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!


Time::DATE_FORMATS[:time_display] = "%B %d, %Y at %I:%M %p"
