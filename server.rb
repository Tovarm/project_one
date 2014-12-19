require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require './lib/connection.rb'
require './lib/class_wiki.rb'


get '/' do
	Mustache.render(File.read('./views/home.html'))
end

get '/new_entry' do
	File.read('./views/new_entry.html')
end

post '/new_entry' do
	entry = Entry.create(title: params["title"], content: params["content"], author: params["author"])
end

get '/entry/:title' do
	Mustache.render(File.read('./views/entry_page'), params["title"], params["content"], param["author"])
end