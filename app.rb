require('sinatra')
require('sinatra/reloader')
require('./app')
require('./lib/movie')
require('./lib/actor')
require('./lib/customer')
require('pg')
require('pry')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'rentals'})

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

get('/find') do
  @found_movies = nil
  @actors = Actor.all
  @movies = Movie.all
  @overdue = nil
  erb(:find)
end
get('/movie_by_actor') do
  @actor = Actor.find_by_name(params.fetch('movie_by_actor'))
  @found_movies = Movie.find_by_actor(@actor.id)

  erb(:find)
end
get('/customer_with_movie') do
  @movie = Movie.find_by_title(params.fetch('title'))
  @customer = Customer.find_by_movie(@movie.id)
  if !@customer
    erb(:not_found)
  else
    @movies = Movie.all
    @in_stock = Movie.in_stock
    erb(:customer)
  end
end

get('/overdue') do
  @overdue = Movie.overdue
  erb(:find)
end

if Movie.all == []
  shelf = {"Die Hard" => ["Bruce Willis"], "Die Hard 2" => ["Bruce Willis"], "Die Hard with a Vengeance" => ["Bruce Willis", "Samuel L Jackson"], "Predator" => ["Arnold Schwarzenegger", "Carl Weathers", "Jesse Ventura"],"Predator 2" => ["Danny Glover"],"Alien" => ["Sigorney Weaver"],"Aliens" => ["Sigorney Weaver"],"Aliens 3" => ["Sigorney Weaver"]}
  shelf.each do |a|
    movie = Movie.new({:id => nil, :title => "#{a[0]}"})
    movie.save
    a[1].each do |b|
      if !Actor.all.any?{|a| a.name == b}
        actor = Actor.new({:id => nil, :name => "#{b}"})
        actor.save
      else
        actor = Actor.find_by_name(b)
      end
      DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor.id}, #{movie.id});")
    end
  end
end
