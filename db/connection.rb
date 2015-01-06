require 'active_record'

# ActiveRecord::Base.establish_connection({
#   :adapter => "postgresql",
#   :host => "localhost",
#   :username => "Tova",
#   :database => "wiki"
#   })
  
  ActiveRecord::Base.establish_connection('postgresql://' + ENV["DB_INFO"]  + '@127.0.0.1/<wiki>')

  ActiveRecord::Base.logger = Logger.new(STDOUT) # <-- optional debugging tool

