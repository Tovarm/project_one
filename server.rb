require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require './db/connection.rb'
require './lib/class_wiki.rb'


get '/' do
	Mustache.render(File.read('./views/index.html'), params.as_json)
end

get '/new_entry' do
	File.read('./views/new_entry.html')
end

post '/new_entry' do
	entry = Entry.create(title: params["title"], content: params["content"], author: params["author"])
	Mustache.render(File.read('./views/confirm_entry.html'), params.as_json)
end

get '/entries_all' do
	all_entries = Entry.all.as_json
# 	Mustache.render(File.read './show_entry_page'), {entry: all_entries})
end

get '/entry/:id' do
	entry = Entry.find_by! id: params["id"]
	Mustache.render(File.read('./views/show_entry_page.html'), params.as_json)
end