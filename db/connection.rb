require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => "postgresql",
  :host => "localhost",
  :username => "Tova",
  :database => "wiki"
  })

  ActiveRecord::Base.logger = Logger.new(STDOUT) # <-- optional debugging tool

  