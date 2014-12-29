
CREATE DATABASE wiki;

CREATE TABLE authors(author_id serial primary key, author_name varchar(50), email varchar(50), phone varchar(30));

CREATE TABLE subscribers(subscriber_id serial primary key, email varchar(50), phone varchar(30));

CREATE TABLE subscriptions(subscription_id serial primary key, subscriber_id integer, entry_id integer);

CREATE TABLE entries(entry_id serial primary key, author_id integer, created_at timestamp, entry_title varchar(255), entry_content text, revision_of integer, updated_at timestamp);

-- CREATE TABLE entries(entry_id serial primary key, author_id integer, version_number integer, created_at timestamp);

-- CREATE TABLE contents(content_id serial primary key, entry_id integer, created_at timestamp, version_number integer, entry_title varchar(100), entry_content text);

-- CREATE TABLE entries(entry_id serial primary key, created_at timestamp, author_id integer, entry_title varchar(255), entry_content text);

-- CREATE TABLE edits(edit_id serial primary key, entry_id integer, author_id integer, edit_number integer, created_at timestamp, edit_title text, edit_content text);

-- CREATE TABLE entry_content()
-- content_id
-- title
-- content
-- entry_id
-- timestamp
-- version number

-- CREATE TABLE entry_meta()
-- unique entry_id
-- author_id
-- timestamp
-- version number