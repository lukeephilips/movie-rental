CREATE DATABASE rentals;
\c rentals;
CREATE TABLE customer (id serial PRIMARY KEY, name varchar, phone varchar);
CREATE TABLE actors (id serial PRIMARY KEY, name varchar);
CREATE TABLE checkouts (id serial PRIMARY KEY, movie_id int, customer_id int);
CREATE TABLE movies_actors (id serial PRIMARY KEY, actor_id int, movie_id int);
CREATE DATABASE rentals_test WITH TEMPLATE rentals;
