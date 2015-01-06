
CREATE DATABASE wiki;

CREATE TABLE authors(author_id serial primary key, author_name varchar(50), email varchar(50), phone varchar(30));

CREATE TABLE subscribers(subscriber_id serial primary key, email varchar(50), phone varchar(30));

CREATE TABLE subscriptions(subscription_id serial primary key, subscriber_id integer, entry_id integer);

CREATE TABLE entries(primary_id serial primary key, entry_id serial, author_id integer, entry_title varchar(100), entry_content text, created_at timestamp);
