require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require './db/connection.rb'
require './lib/class_wiki.rb'


post '/search_results' do
	"You searched for: #{params["search"]}"
	# entry = Entry.all.to_a
	entry = Entry.where("entry_title like ?", "%" + params["search"] + "%").to_a
	# entry = Entry.find_by_entry_title("#{params['search']}")
 # binding.pry
		if params["search"].downcase == entry["entry_title"]
			return "There is a match"
		else 
			return "Sorry, no matches found"
		end
end

get '/' do
	Mustache.render(File.read('./views/index.html'), params.to_a)
end

get '/new_entry' do
	File.read('./views/new_entry.html')
end

post '/new_entry' do
	Entry.create(entry_title: params["entry_title"], entry_content: params["entry_content"], author_id: params[
		"author"])
	Mustache.render(File.read('./views/confirm_entry.html'), params.to_a)
end


get '/subscribe' do
	File.read('./views/subscribe.html')
end

post '/confirm_subscription' do
	Subscriber.create(name: params["name"], email: params["email"], phone: params["phone"])
	Mustache.render(File.read('./views/confirm_subscription.html'), params.as_json)
end


get '/new_author' do
	File.read('./views/new_author.html')
end

post '/new_author' do
	Author.create(name: params["author_name"])
	Mustache.render(File.read('./views/confirm_author.html'), params.as_json)
end


# show a specific entry
get '/entry/:id' do

	Entry.find_by entry_id: params["entry_id"]
	Mustache.render(File.read('./views/show_entry_page.html'), params.as_json)
end

# get '/entries_all' do
# 	all_entries = Entry.all
# 	Mustache.render(File.read './show_entry_page'), {entry: all_entries}.to_a)
# end


