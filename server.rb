require './lib/class_wiki.rb'
require './db/connection.rb'
require './sendgrid_api.rb'
require 'pry'
require 'sinatra'
require 'mustache'
require 'redcarpet'
require 'sendgrid-ruby'
require 'twilio-ruby'
require 'sinatra/reloader'

after do
  ActiveRecord::Base.connection.close
end


# SEARCH  (downcase???)  -----------------------------------------------------------------
post '/search_results' do
	if params["search"] == ""
		return "Please enter a search term"
	elsif Entry.exists?(:entry_title => params["search"])
	# elsif Entry.exists?(['entry_title LIKE ?', "%#{params["search"]}%"])
  		entry = Entry.where(:entry_title => params["search"]).last
  		Mustache.render(File.read('./views/search_results.html'), {entry_title: params["search"], entry: entry.as_json})
	else 
		return "Your search for: '#{params["search"]}' DID NOT RETURN any matches"
	end
end

#-----------------------------------------------------------------------------------------
get '/' do
	entries = Entry.where(primary_id: Entry.group("entry_id").maximum("primary_id").to_a)
# binding.pry
	Mustache.render(File.read('./views/index.html'), {entries: entries.as_json})
end


get '/new_entry' do
	authors = Author.all.order(:author_name)
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
	elsif params["email"] !~ (/\w+@\w+\.com/)
		return "Please enter a valid email address"
	else
		Author.create(author_name: params["author_name"], email: params["email"], phone: params["phone"])
		Mustache.render(File.read('./views/confirm_author.html'), params.as_json)
	end
end


get '/all_authors' do
	author = Author.all
	Mustache.render(File.read('./views/all_authors.html'), {author: author.to_a})
end

get '/subscribe/:id' do
# binding.pry
	Mustache.render(File.read('./views/subscribe.html'), {entry_id: params["id"]})
end

post '/subscribe/:id' do
# binding.pry	
	if params["email"].chomp == "" && params["phone"].chomp == ""
		return "Please enter an email address or phone number"
	elsif params["email"] !~ (/\w+@\w+\.com/)
		return "Please enter a valid email address"
	elsif Subscriber.exists?(:email => "#{params["email"]}") 

	elsif Subscriber.exists?(:subscriber_id => "#{params["subscriber_id"]}")
		Subscription.create(subscriber_id: subscriber.subscriber_id, entry_id: params["id"])
		Mustache.render(File.read('./views/confirm_subscription.html'), params.as_json)

	else
		subscriber = Subscriber.create(email: params["email"], phone: params["phone"])
		Subscription.create(subscriber_id: subscriber.subscriber_id, entry_id: params["id"])
		entry = Entry.where(entry_id: params["id"])
		Mustache.render(File.read('./views/confirm_subscription.html'), params.as_json)

	end
end

get '/entry/:id' do
# binding.pry
	entry = Entry.where(entry_id: params["id"]).last
	author = Author.find_by(author_id: entry.author_id)
# binding.pry
	markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new({hard_wrap: true}))
 	rendered = markdown.render(entry.entry_content)
	template = Mustache.render(File.read('./views/show_entry_page.html'), {entry: entry.as_json, author: author.as_json, rendered: rendered})
end

get '/author/:id' do
# binding.pry
	entry = Entry.where(author_id: params["id"])
	author = Author.find_by author_id: params["id"]
	Mustache.render(File.read('./views/author_page.html'), {author: author.as_json, entry: entry.to_a})
end

get '/edit/entry/:id' do
	entry = Entry.where(entry_id: params["id"]).last
	authors = Author.all.order(:author_name)
	Mustache.render(File.read('./views/update_entry.html'), {authors: authors.as_json, entry: entry.as_json})
end

put '/edit/entry/:id' do
	if params["author_id"] == "0"
		return "Please choose an author from the dropdown list, or go back to add a new one"
	elsif params["entry_title"] == "" || params["entry_content"] == ""
		return "Please enter a title and an entry"
	else
		author = Author.where(author_id: params["author_id"])
		entry = Entry.create(entry_id: params["id"], author_id: params["author_id"], entry_title: params["entry_title"], entry_content: params["entry_content"])
#-------------- notifications -------------#
	subscriber = Subscriber

	notification = Mustache.render(File.read('./notify.html'), {entry: entry.as_json})
# binding.pry
#-------------- Sendgrid ------------------#
  client = SendGrid::Client.new do |client|
  client.api_user = 'tovarm'
  client.api_key = 'sendgrid33'
end

mail = SendGrid::Mail.new do |message|
  message.to = ["tovamosk@gmail.com"],
  message.from = 'blob@blobby.com'
  message.subject = 'Edit notification'
  message.text = notification
end
	# puts client.send(mail)
#---------------- Sendgrid -----------------#
#---------------- twilio -------------------#
account_sid = 'ACbb965bef42d969da2a19e0fb68d75577' 
auth_token = '97f0553078b9b21f1b52d2f185e1ea41' 
 
@client = Twilio::REST::Client.new account_sid, auth_token 
 
# @client.account.messages.create({
# 	:from => '+13479675006',
# 	:to => '9176648369',
# 	:body => notification    
# })
#---------------- twilio -------------------#
	Mustache.render(File.read('./views/confirm_update.html'), {entry: entry.as_json, author: author.as_json})
	end
end
# binding.pry

	
get '/delete/entry/:id' do
	entry = Entry.where(entry_id: params["id"]).last
	Mustache.render(File.read('./views/delete.html'), {entry: entry.as_json})
# binding.pry
end


delete '/delete/entry/:id' do
	entry = Entry.where(entry_id: params["id"]).select("primary_id").to_a
# binding.pry
	deleted_entries = Entry.destroy(entry)
	entry = Entry.find_by(entry_id: params["id"])
	Mustache.render(File.read('./views/confirm_delete.html'), {entry: entry.as_json})
end

get '/history/:id' do
	entry = Entry.where(entry_id: params["id"]).order(:primary_id)
	Mustache.render(File.read('./views/history.html'), {entry: entry.as_json, entry_title: params["entry_title"]})
end

get '/entry/:id/:primary_id' do
# binding.pry
	entry = Entry.find_by(entry_id: params["id"], primary_id: params["primary_id"])
	author = Author.find_by(author_id: entry.author_id)
	markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new({hard_wrap: true}))
 	rendered = markdown.render(entry.entry_content)
	template = Mustache.render(File.read('./views/indiv_history.html'), {entry: entry.as_json, author: author.as_json, rendered: rendered})

	Mustache.render(File.read('./views/indiv_history.html'), {entry: entry.as_json, author: author.as_json, rendered: rendered.as_json})
end 