class Termcap2 < ActiveRecord::Base
  self.abstract_class = true
  establish_connection TERMCAP2
  #establish_connection(ENV['HEROKU_POSTGRESQL_BRONZE_URL'])

end