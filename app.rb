require('sinatra')
require('sinatra/reloader')
require('./app')
require('./lib/movie')
require('./lib/actor')
require('./lib/customer')
require('pg')
require('pry')
also_reload('lib/**/*.rb')

get('/') do
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
  erb(:index)
end

get('/login/customer') do
  name = params['name']
  cust = Customer.find_by_name(name)
  if cust != nil
    all_of = Customer.all
    if all_of.include?(cust)
      @customer = cust
      @movies = Movie.all
      @in_stock = Movie.in_stock
      (:customer)
    else
      @customers = all_of
      @movies = Movie.all
      @in_stock = Movie.in_stock
      (:index)
    end
  end
end

get('/customer/:id') do
  @customer = Customer.find_by_id(params['id'].to_i)
  @movies = Movie.all
  @in_stock = Movie.in_stock
  erb(:customer)
end

post('/customer/new') do
  @customer = Customer.new({:id => nil, :name => params['name']})
  @customer.save
  @customers = Customer.all
  @movies = Movie.all
  @in_stock = Movie.in_stock
  erb(:customer)
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
delete('/customer/:id/return') do
  @customer = Customer.find_by_id(params['id'].to_i)
  movie_ids = params.fetch('movie_ids',[])
  @customer.return({:movie_ids => movie_ids})

  @movies = Movie.all
  @in_stock = Movie.in_stock
erb(:customer)
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

DB = PG.connect({:dbname => 'rentals_test'})
movie = Movie.new({:id => nil, :title => "Die Hard"})
movie.save
actor = Actor.new({:id => nil, :name => "Bruce Willis"})
actor.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")

movie = Movie.new({:id => nil, :title => "Die Hard 2"})
movie.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
movie = Movie.new({:id => nil, :title => "Die Hard with a Vengeance"})
movie.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
actor = Actor.new({:id => nil, :name => "Samuel L Jackson"})
actor.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
movie = Movie.new({:id => nil, :title => "Predator"})
movie.save
actor = Actor.new({:id => nil, :name => "Arnold Schwarzenegger"})
actor.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
movie = Movie.new({:id => nil, :title => "Predator 2"})
movie.save
actor = Actor.new({:id => nil, :name => "Danny Glover"})
actor.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
movie = Movie.new({:id => nil, :title => "Alien"})
movie.save
actor = Actor.new({:id => nil, :name => "Sigorney Weaver"})
actor.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
movie = Movie.new({:id => nil, :title => "Aliens"})
movie.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
movie = Movie.new({:id => nil, :title => "Aliens 3"})
movie.save
DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
