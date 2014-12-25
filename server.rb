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
	entry = Entry.where("entry_title like ?", "%" + params["search"] + "%").to_a
	# entry = Entry.find_by_entry_title("#{params['search']}")
 # binding.pry
		if params["search"].downcase == HEllo
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

get '/subscribe' do
	entries = Entry.all
	Mustache.render(File.read('./views/subscribe.html'), {entries: entries.as_json})
end



post '/subscribe' do
# binding.pry	
	if params["email"] == "" && params["phone"] == "" || params["email"] == " " && params["phone"] == " "
		return "Please enter an email address or phone number"
	else
	Subscriber.create(email: params["email"], phone: params["phone"])
	Subscription.create(subscriber_id: params["subscriber_id"], entry_id: params["entry_id"])
	Mustache.render(File.read('./views/confirm_subscription.html'), params.as_json)
	end
end

get '/new_author' do
	File.read('./views/new_author.html')
end


post '/new_author' do
	if params["email"] == "" && params["phone"] == "" || params["email"] == " " && params["phone"] == " "
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
	Mustache.render(File.read('./views/all_authors.html'))
end

get '/entry/:id' do
	# binding.pry
	authors = Author.all
	Mustache.render(File.read('./views/show_entry_page.html'), {authors: authors})
	entry = Entry.find_by entry_id: params["id"]
	Mustache.render(File.read('./views/show_entry_page.html'), {entry: entry})
end


get '/edit/entry/:id' do
	authors = Author.all
	Mustache.render(File.read('./views/update_entry.html'), {authors: authors.as_json})
end

get '/author/:id' do
# binding.pry
	author = Author.find_by author_id: params["id"]
	Mustache.render(File.read('./views/author_page.html'), {author: author.as_json})
end

put '/edit/entry/:id' do
	if params["author_id"] == "0"
		return "Please choose an author from the dropdown list, or go back to add a new one"
	elsif params["entry_title"] == "" || params["entry_content"] == ""
		return "Please enter a title and an entry"
	entry = Entry.find_by(entry_id: params["id"])
binding.pry
	entry.entry_title = params["entry_title"]
	entry.entry_content = params["entry_content"]

	Mustache.render(File.read('./views/confirm_update.html'), params.as_json)
	end
end


# delete '/entry/:id' do
# 	entry = Entry.find_by name: params["id"]
# binding.pry
# 	entry.destroy
# end

# delete '/pages/:id' do
#   Page.find(params[:id]).destroy
#   redirect to('/pages')
# end
