require 'pry'
require 'sendgrid-ruby'
require './db/connection.rb'
require './lib/class_wiki.rb'


  client = SendGrid::Client.new do |client|
  client.api_user = 'tovarm'
  client.api_key = 'sendgrid33'
end

mail = SendGrid::Mail.new do |message|
  message.to = ["tovamosk@gmail.com"]
  message.from = 'blob@blobby.com'
  message.subject = 'Update notification!'
  message.text = 'This is to notify you that the Wiki entry you subscribed to- {{entry_title}}- has been modified'
end

# puts client.send(mail)

# subscriber = Subscriber.all

# subscriber.each do |person|                                                                                    
# subscriber = person["email"]                                                                                         
# # binding.pry
# end





