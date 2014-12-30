require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require './db/connection.rb'
require './lib/class_wiki.rb'

# SEARCH  (downcase???)  -----------------------------------------------------------------
post '/search_results' do
	if params["search"] == ""
		return "Please enter a search term"
	# if Entry.exists?(:entry_title => params["search"])
	elsif Entry.exists?(['entry_title LIKE ?', "%#{params["search"]}%"])
  		entry = Entry.where(:entry_title => params["search"]).last
  		Mustache.render(File.read('./views/search_results.html'), {entry_title: params["search"], entry: entry.as_json})
	else 
		return "Your search for: '#{params["search"]}' DID NOT RETURN any matches"
	end
end

#-----------------------------------------------------------------------------------------
get '/' do
	# entries = Entry.order(:created_at).last

	entries = Entry.where(primary_id: Entry.maximum("primary_id").group(:entry_id))
binding.pry
	# entries = Entry.all

	# entries = entries.order(:created_at)
	Mustache.render(File.read('./views/index.html'), {entries: entries.as_json})
end




	# entries = Entry.where(:revision_of => params["entry_id"])

	# entry = Entry.order(:revision_of)
	# entries = Entry.order(entry)


# Entry.find
# entries = Entry.exists?(:revision_of => params["entry_id"])


# binding.pry
# if entry_id exists in revision_of column, show most updated row of that entry_id in the revision_of column
# 	if entry_id doesn't exist in revision_of column, show that row where revision_of 0

	
	# entries = Entry.where.not(revision_of: 0)
	 

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
	author = Author.where(author_id: params["author_id"])
	Entry.create(author_id: params["author_id"], entry_title: params["entry_title"], entry_content: params["entry_content"])
	entry = Entry.where(entry_title: params["entry_title"])
# binding.pry
	Mustache.render(File.read('./views/confirm_entry.html'), {entry: entry.to_a, author: author.to_a})
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
	# entry = Entry.where(entry_id: params["id"])
# binding.pry
	# entry = Entry.find_by entry_id: params["id"]
	entry = Entry.where(entry_id: params["id"])
	Mustache.render(File.read('./views/show_entry_page.html'), {author: author.to_a, entry: entry.as_json})
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
	if params["author_id"] == "0"
		return "Please choose an author from the dropdown list, or go back to add a new one"
	elsif params["entry_title"] == "" || params["entry_content"] == ""
		return "Please enter a title and an entry"
	else
		author = Author.where(author_id: params["author_id"])
		# # old_entry = Entry.where(entry_id: param	s["id"])
		entry = Entry.create(entry_id: params["id"], author_id: params["author_id"], entry_title: params["entry_title"], entry_content: params["entry_content"])
	Mustache.render(File.read('./views/confirm_update.html'), {entry: entry.as_json, author: author.as_json})
	end
end
# binding.pry

	# entry = Entry.find_by(entry_id: params["id"])
	# entry.entry_title = params["entry_title"]
	# entry.entry_content = params["entry_content"]
	# entry.author_id = params["author_id"]
	# entry.revision_of = params["id"]
	# entry.save
	



get '/delete/entry/:id' do
	entry = Entry.where(entry_id: params["id"])
	Mustache.render(File.read('./views/delete.html'), {entry: entry.to_a})
# binding.pry
end

delete '/delete/entry/:id' do
	# l = Location.where(["entry_id = ?", params["id"]).select("primary_id")


entry = Entry.where(entry_id: params["id"]).select("primary_id").to_a
# binding.pry


	deleted_entries = Entry.destroy(entry)
# 	entry = Entry.where(entry_id: params["id"]).destroy
	Mustache.render(File.read('./views/confirm_delete.html'), {entry: deleted_entries.as_json})
end

get '/history/:id' do
	# new_entry = Entry.where(revision_of: params["id"])

	entry = Entry.where(entry_id: params["id"])
	# entry = Entry.where(entry_id: params["id"])
	Mustache.render(File.read('./views/history.html'), {entry: entry.as_json})
end

