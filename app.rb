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
  @cast = @movie.actors
  erb(:movie)
end
post('/movie/new') do
  @movie = Movie.new({:id => nil, :title => params['title']})
  @movie.save
  actor_name = params.fetch("name")
  actor_name.each() do |name|
    actor = Actor.new({:id => nil, :name => name })
    actor.save
    @movie.update(:actor_ids => [actor.id])
  end
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
  @cast = @movie.actors
  erb(:index)
end
patch('/movie/:id') do
  @movie = Movie.find_by_id(params['id'].to_i)
  if params['title'] == ''
    new_actor = Actor.new(:id => nil, :name => params["name"])
    new_actor.save
    @movie.update(:actor_ids => [new_actor.id])
    @cast = @movie.actors
  elsif params['name'] == ''
   @movie.update(:title => params['title'])
   @cast = @movie.actors
  else
   @movie.update(:title => params['title'])
   new_actor = Actor.new(:id => nil, :name => params["name"])
   new_actor.save
   @movie.update(:actor_ids => [new_actor.id])
   @cast = @movie.actors
  end
  erb(:movie)
end
delete('/movie/:id/delete') do
  @movie = Movie.find_by_id(params['id'].to_i)
  Movie.delete(@movie)
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
  @cast = @movie.actors
erb(:index)
end
