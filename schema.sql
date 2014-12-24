
CREATE DATABASE wiki;


CREATE TABLE entries(entry_id serial primary key, author_name varchar(100), author_id integer, entry_title varchar(255), entry_content text);

CREATE TABLE authors(author_id serial primary key, author_first_name varchar(50), author_last_name varchar(50), email varchar(50), phone varchar(50));

CREATE TABLE subscribers(subscriber_id serial primary key, sub_first_name varchar(50), sub_last_name varchar(50), email varchar(50), phone varchar(50));

CREATE TABLE subscriptions(subscription_id serial primary key, subscriber_id integer, entry_id integer);


CREATE TABLE edits(edit_id serial primary key, entry_id integer, author_id integer, edit_number integer, edit_timestamp date, edit_title text, edit_content text);