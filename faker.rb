require 'pry'
require 'Faker'
require 'active_record'
require './lib/class_wiki'
require './db/connection.rb'


10.times do |author|
author = Author.create(author_name: Faker::Name.name, email: Faker::Internet.free_email, phone: Faker::PhoneNumber.phone_number )	
end


# 10.times do |subscriber|
# subscriber = Subscriber.create(email: Faker::Internet.free_email, phone: Faker::PhoneNumber.phone_number )	
# end


# 50.times do |entry|
# 	entry = Entry.create

# insert column 'author_id' from authors table into entries table