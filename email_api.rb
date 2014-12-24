require 'pry'
require 'sendgrid-ruby'
require './db/connection.rb'
require './lib/class_wiki.rb'

  client = SendGrid::Client.new do |client|
  client.api_user = 'tovarm'
  client.api_key = 'sendgrid33'
end


subscriber = Subscriber.all

subscriber.each do |person|                                                                                    
subscriber = person["email"]                                                                                         
# binding.pry
end




mail = SendGrid::Mail.new do |message|
  # message.to = subscriber
  message.from = 'tovamosk@gmail.com'
  message.subject = 'Hello world!'
  message.text = 'Here I am'
end

puts client.send(mail)

