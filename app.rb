

get('/') do

  erb(:index)
end

post('movies/new') do

  Movie.new({:id => nil, :title => params['title']}).save
  Actor.new({:id => nil, :name => params['name']}).save
  # call to movies to get ID
  # call to actors to get ID
  # Join actors and movies using IDs


  erb(:movies)
end
