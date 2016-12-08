require('sinatra')
require('sinatra/reloader')
require('./app')
require('./lib/movie')
require('./lib/actor')
require('./lib/customer')
require('pg')
require('pry')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'rentals_test'})


get('/') do
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
  erb(:index)
end

get('/customer/:id') do
  @customer = Customer.find_by_id(params['id'].to_i)
  @movies = Movie.all
  @in_stock = Movie.in_stock
erb(:customer)
end
post('/customer/new') do
  Customer.new({:id => nil, :name => params['name']}).save
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
  erb(:index)
end
patch('/customer/:id') do
  @customer = Customer.find_by_id(params['id'].to_i)

  movie_ids = params.fetch('movie_ids',[])
  name = params.fetch('name', @customer.name)
  @customer.checkout({:movie_ids => movie_ids, :name => name})
  @movies = Movie.all
  @in_stock = Movie.in_stock
  erb(:customer)
end
delete('/customer/:id/delete') do
  @customer = Customer.find_by_id(params['id'].to_i)
  Customer.delete(@customer)
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
erb(:index)
end


get('/movie/:id') do
  @movie = Movie.find_by_id(params['id'].to_i)
  erb(:movie)
end
post('/movie/new') do
  movie = Movie.new({:id => nil, :title => params['title']})
  movie.save
  actor = Actor.new({:id => nil, :name => params['name']})
  actor.save
  @join = DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
  erb(:index)
end
patch('/movie/:id') do
  @movie = Movie.find_by_id(params['id'].to_i)
  @movie.update(:title => params['title'])
  erb(:movie)
end
delete('/movie/:id/delete') do
  @movie = Movie.find_by_id(params['id'].to_i)
  Movie.delete(@movie)
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
erb(:index)
end
