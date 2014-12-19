

CREATE DATABASE wiki;

CREATE TABLE authors(
	id serial primary key, 
	name varchar(50), 
	how_many_entries integer, 
	entry_ids integer);

CREATE TABLE entries(
	id serial primary key, 
	title varchar(100), 
	author varchar(100), 
	date date, time time, 
	content text, 
	subscriber_ids integer, 
	history text);

CREATE TABLE subscribers(
	id serial primary key, 
	email text, 
	phone_number varchar(11), 
	entry_id integer);

CREATE TABLE edits(id serial primary key,
	author_id integer,
	entry_id integer,
	date date,
	title varchar(100),
	content text);