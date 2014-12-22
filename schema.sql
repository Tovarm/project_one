
CREATE DATABASE wiki;

# CREATE TABLE entries(id serial primary key, author_id integer, date date, title varchar(100), content text, subscriber_id integer, edit_number integer, edit_date date, edit_title varchar(100), edit_content text);

# CREATE TABLE authors(id serial primary key, name varchar(50), entry_id integer);


# CREATE TABLE subscribers(id serial primary key, name varchar(50), email text,phone varchar(14), entry_id integer);


CREATE TABLE entries(entry_id serial primary key, author_id integer, subscriber_id integer, entry_title varchar(255), entry_content text);

CREATE TABLE authors(author_id serial primary key, name varchar(50), entry_id integer);

CREATE TABLE subscribers(subscriber_id serial primary key, name varchar(50), email text, phone varchar(14));

CREATE TABLE edits(edit_id serial primary key, entry_id integer, author_id integer, edit_number integer, edit_timestamp date, edit_title text, edit_content text); 
