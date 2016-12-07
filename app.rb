require('sinatra')
require('sinatra/reloader')
require('./app')
require('./lib/movie')
require('./lib/actor')
require('./lib/customer')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'rentals_test'})


get('/') do
  @customers = Customer.all
  @movies = Movie.all
  erb(:index)
end

post('/movies/new') do

  Movie.new({:id => nil, :title => params['title']}).save
  Actor.new({:id => nil, :name => params['name']}).save
  # call to movies to get ID
  # call to actors to get ID
  # Join actors and movies using IDs
  @customers = Customer.all
  @movies = Movie.all

  erb(:index)
end

post('/customers/new') do
  Customer.new({:id => nil, :name => params['name']}).save
  @customers = Customer.all
  @movies = Movie.all
  erb(:index)
end

get('/customer/:id') do
  @customer = Customer.find_by_id(params['id'].to_i)
  @movies = Movie.all
erb(:customer)
end
delete('/customer/:id/delete') do
  @customer = Customer.find_by_id(params['id'].to_i)
  Customer.delete(@customer)
  @customers = Customer.all
  @movies = Movie.all
erb(:index)
end

get('/movie/:id') do
  @movie = Movie.find_by_id(params['id'].to_i)
erb(:movie)
end

delete('/movie/:id/delete') do
  @movie = Movie.find_by_id(params['id'].to_i)
  Movie.delete(@movie)
  @customers = Customer.all
  @movies = Movie.all
erb(:index)
end
