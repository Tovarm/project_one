require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require './db/connection.rb'
require './lib/class_wiki.rb'


get '/' do
	Mustache.render(File.read('./views/index.html'), params.to_a)
end

get '/new_entry' do
	File.read('./views/new_entry.html')
end


# get '/entries_all' do
# 	all_entries = Entry.all
# 	Mustache.render(File.read './show_entry_page'), {entry: all_entries}.to_a)
# end

# show a specific entry

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
get '/new_author' do
	File.read('./views/new_author.html')
end

post '/new_author' do
	Author.create(name: params["author_name"])
	Mustache.render(File.read('./views/confirm_author.html'), params.as_json)
end

post '/new_entry' do
	Entry.create(entry_title: params["entry_ title"], entry_content: params["entry_content"], author_id: params[
		"author"])
	Mustache.render(File.read('./views/confirm_entry.html'), params.as_json)
end

get '/entry/:id' do
	entry = Entry.find_by id: params["id"]
	Mustache.render(File.read('./views/show_entry_page.html'), params.as_json)
end



