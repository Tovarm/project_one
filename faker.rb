require 'pry'
require 'Faker'
require 'active_record'
require './lib/class_wiki'
require './db/connection.rb'


50.times do |author|
author = Author.create(author_first_name: Faker::Name.first_name, author_last_name: Faker::Name.last_name, email: Faker::Internet.free_email, phone: Faker::PhoneNumber.phone_number )	
end


50.times do |subscriber|
subscriber = Subscriber.create(sub_first_name: Faker::Name.first_name, sub_last_name: Faker::Name.last_name, email: Faker::Internet.free_email, phone: Faker::PhoneNumber.phone_number )	
end


50.times do |entry|
	entry = Entry.create

# insert column 'author_id' from authors table into entries table