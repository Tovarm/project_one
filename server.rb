require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require './db/connection.rb'
require './lib/class_wiki.rb'

# SEARCH  (downcase???)__-----------------------------------------------------------------
post '/search_results' do
	# if Entry.exists?(:entry_title => params["search"])
	if Entry.exists?(['entry_title LIKE ?', "%#{params["search"]}%"])
  		entry = Entry.where(:entry_title => params["search"])
  		Mustache.render(File.read('./views/search_results.html'), {entry_title: params["search"], entry: entry.to_a})
	else 
		return "Your search for: '#{params["search"]}' DID NOT RETURN any matches"
	end
end

#-----------------------------------------------------------------------------------------

get '/' do
	entries = Entry.all
	Mustache.render(File.read('./views/index.html'), {entries: entries.to_a})
end

get '/new_entry' do
	authors = Author.all
	Mustache.render(File.read('./views/new_entry.html'), {authors: authors.to_a})
end

post '/new_entry' do
# binding.pry
	if params["entry_title"] == "" || params["entry_content"] == ""
		return "Please enter a title and an entry"
	elsif params["author_id"] == "0"
		return "Please choose an author from the dropdown list or go back and add a new one"
	else
	Entry.create(entry_title: params["entry_title"], entry_content: params["entry_content"], author_id: params[
		"author_id"], revision_number: 0)
	entry = Entry.where(entry_title: params["entry_title"])
# binding.pry
	Mustache.render(File.read('./views/confirm_entry.html'), entry: entry.to_a)
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
	Mustache.render(File.read('./views/all_authors.html'), {author: author.to_a})
end

post '/subscribe/:id' do
# binding.pry	
	if params["email"].chomp == "" && params["phone"].chomp == ""
		return "Please enter an email address or phone number"
	else
	subscriber = Subscriber.create(email: params["email"], phone: params["phone"])
	Subscription.create(subscriber_id: subscriber.subscriber_id, entry_id: params["id"])
	entry = Entry.where(entry_id: params["id"])
	Mustache.render(File.read('./views/confirm_subscription.html'), params.as_json)
	end
end

get '/subscribe/:id' do
# binding.pry
	Mustache.render(File.read('./views/subscribe.html'), {entry_id: params["id"]})
	# entries = Entry.all
	# Mustache.render(File.read('./views/subscribe.html'), {entries: entries.to_a})
end

###### work on getting the author name to show up instead of the author id ######
get '/entry/:id' do
	author = Author.where(author_id: params["author_id"])
	entry = Entry.where(entry_id: params["id"])
# binding.pry
	# entry = Entry.find_by entry_id: params["id"]
	Mustache.render(File.read('./views/show_entry_page.html'), {author: author.as_json, entry: entry.to_a})
end

get '/author/:id' do
# binding.pry
	entry = Entry.where(author_id: params["id"])
	author = Author.find_by author_id: params["id"]
	Mustache.render(File.read('./views/author_page.html'), {author: author.as_json, entry: entry.to_a})
end

get '/edit/entry/:id' do
	entry = Entry.where(entry_id: params["id"])
	authors = Author.all
	Mustache.render(File.read('./views/update_entry.html'), {authors: authors.to_a, entry: entry.to_a})
end

put '/edit/entry/:id' do
# binding.pry
	if params["author_id"] == "0"
		return "Please choose an author from the dropdown list, or go back to add a new one"
	elsif params["entry_title"] == "" || params["entry_content"] == ""
		return "Please enter a title and an entry"
	# entry = Entry.find_by(entry_title: "Marvin")
	entry.entry_title = params["entry_title"]
	entry.entry_content = params["entry_content"]
	revision_number = revision_number += 1
	entry.save
	udpate = Entry.create(entry_id: params["id"], author_id: params["id"], edit_title: params["edit_title"], edit_content: params["edit_content"], revision_number: revision_number += 1, revised_at: timestamp)
	Mustache.render(File.read('./views/confirm_update.html'), {entry: entry.to_a})

	end
end

get '/delete/entry/:id' do
	entry = Entry.where(entry_id: params["id"])
	Mustache.render(File.read('./views/delete.html'), {entry: entry.to_a})
# binding.pry
end

delete '/delete/entry/:id' do
binding.pry
	entry = Entry.where(entry_id: params["id"])
	entry.destroy

end

