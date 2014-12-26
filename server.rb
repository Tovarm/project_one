require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require './db/connection.rb'
require './lib/class_wiki.rb'

# SEARCH --------------------------------------------------------------------------------
post '/search_results' do
	"You searched for: #{params["search"]}"
	# entry = Entry.all.to_a
	entry = Entry.where(:entry_title => "#{params["search"].downcase}").to_a
 # binding.pry

	# entry = Entry.find_by_entry_title("#{params['search']}")
		if params["search"].downcase == entry
			return "There is a match"
		else 
			return "Sorry, no matches found"
		end
end
#-----------------------------------------------------------------------------------------

get '/' do
	entries = Entry.all
	Mustache.render(File.read('./views/index.html'), {entries: entries.as_json})
end

get '/new_entry' do
	authors = Author.all
	Mustache.render(File.read('./views/new_entry.html'), {authors: authors.as_json})
end

post '/new_entry' do
# binding.pry
	if params["entry_title"] == "" || params["entry_content"] == ""
		return "Please enter a title and an entry"
	elsif params["author_id"] == "0"
		return "Please choose an author from the dropdown list or go back and add a new one"
	else
	Entry.create(entry_title: params["entry_title"], entry_content: params["entry_content"], author_id: params[
		"author_id"])
# binding.pry
	Mustache.render(File.read('./views/confirm_entry.html'), params.as_json)
	end
end


post '/subscribe/:id' do
# binding.pry	
	if params["email"].chomp == "" && params["phone"].chomp == ""
		return "Please enter an email address or phone number"
	else
	subscriber = Subscriber.create(email: params["email"], phone: params["phone"])

	Subscription.create(subscriber_id: subscriber.subscriber_id, entry_id: params["id"])
	Mustache.render(File.read('./views/confirm_subscription.html'), params.as_json)
	end
end

get '/new_author' do
	File.read('./views/new_author.html')
end


post '/new_author' do
	if params["email"].chomp == "" && params["phone"].chomp == ""
		return "Please enter an email address and/or phone number"
	elsif params["author_name"] == ""
		return "Please enter author's name"
	elsif Author.exists?(:author_name => "#{params["author_name"]}")
		return "That author already exists"
	elsif Author.exists?(:email => "#{params["email"]}")
		return "That email already exists"
	elsif Author.exists?(:phone => "#{params["phone"]}")
		return "That phone number already exists"
	else
	
	Author.create(author_name: params["author_name"], email: params["email"], phone: params["phone"])
	Mustache.render(File.read('./views/confirm_author.html'), params.as_json)
	end
end


get '/all_authors' do
	author = Author.all
	Mustache.render(File.read('./views/all_authors.html'), {author: author.as_json})
end

get '/subscribe/:id' do
# binding.pry

	Mustache.render(File.read('./views/subscribe.html'), {entry_id: params["id"]})

	# entries = Entry.all
	# Mustache.render(File.read('./views/subscribe.html'), {entries: entries.as_json})
end

get '/entry/:id' do
	# binding.pry
	authors = Author.all
	entry = Entry.where(entry_id: params["id"])
	# entry = Entry.find_by entry_id: params["id"]
	Mustache.render(File.read('./views/show_entry_page.html'), {authors: authors.as_json, entry: entry.as_json})
	# Mustache.render(File.read('./views/show_entry_page.html'), {entry: entry})
end

get '/author/:id' do
# binding.pry
	entry = Entry.where(author_id: params["id"])
	author = Author.find_by author_id: params["id"]
	Mustache.render(File.read('./views/author_page.html'), {author: author.as_json, entry: entry.as_json})
	# Mustache.render(File.read('./views/author_page.html'), {entry: entry.as_json})
end

get '/edit/entry/:id' do
	authors = Author.all
	Mustache.render(File.read('./views/update_entry.html'), {authors: authors.as_json})
end

put '/edit/entry/:id' do
	if params["author_id"] == "0"
		return "Please choose an author from the dropdown list, or go back to add a new one"
	elsif params["entry_title"] == "" || params["entry_content"] == ""
		return "Please enter a title and an entry"
	entry = Entry.find_by(entry_id: params["id"])
binding.pry
	# entry.entry_title = params["entry_title"]
	# entry.entry_content = params["entry_content"]
	edit = Edit.create(entry_id: params["id"], author_id: params["author_id"], edit_number: params["edit_number"], edit_title: params["edit_title"], edit_content: params["edit_content"])
	entry = Entry.all
	Mustache.render(File.read('./views/confirm_update.html'), {entry: entry.as_json})
	# entry.save
	end
end
 # edit_id | entry_id | author_id | edit_number | created_at | edit_title | edit_conten


# delete '/entry/:id' do
# 	entry = Entry.find_by name: params["id"]
# binding.pry
# 	entry.destroy
# end

# delete '/pages/:id' do
#   Page.find(params[:id]).destroy
#   redirect to('/pages')
# end
