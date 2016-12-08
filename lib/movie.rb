class Movie
  attr_reader(:id, :title)
  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
  end

# JOIN METHODS
  def update(attributes) #patch movies_actors
    @id = self.id
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE movies SET title = '#{@title}' WHERE id = #{@id};")

    attributes.fetch(:actor_ids, []).each do |actor_id|
      DB.exec("INSERT INTO movies_actors (actor_id, movie_id) VALUES (#{actor_id}, #{self.id});")
    end
  end

  def actors #read movies_actors
    movie_actors =[]
    results = DB.exec("SELECT actor_id FROM movies_actors WHERE movie_id = #{self.id};")
    results.each do |result|
      actor_id = result.fetch('actor_id').to_i
      actor = DB.exec("SELECT * FROM actors WHERE id = #{actor_id};")
      name = actor.first().fetch('name')
      movie_actors.push(Actor.new({:name => name, :id => actor_id}))
    end
    movie_actors
  end

  def history #read checkouts
    checked_out = []
    results = DB.exec("SELECT customer_id FROM checkouts WHERE movie_id = #{self.id};")
    results.each do |result|
      customer_id = result.fetch('customer_id').to_i
      customer = DB.exec("SELECT * FROM customer WHERE id = #{customer_id};")
      name = customer.first.fetch('name')
      checked_out.push(Actor.new({:name => name, :id => customer_id}))
    end
    checked_out
  end

  def save
    result = DB.exec("INSERT INTO movies (title) VALUES ('#{@title}') RETURNING id;")
     @id = result[0]['id'].to_i
   end

   def self.all
     returned_movies = DB.exec("SELECT * FROM movies;")
     movies = []
     returned_movies.each do |movie|
       id = movie['id']
       title = movie['title']
       movies.push(Movie.new({:id => id, :title => title}))
     end
     movies
   end
   def self.find_by_id(id)
     movie = DB.exec("SELECT * FROM movies WHERE id = #{id};")
     id = movie.first['id']
     title = movie.first['title']
     found_movie = Movie.new({:id => id, :title => title})
   end
   def self.find_by_title(title)
     movie = DB.exec("SELECT * FROM movies WHERE title = '#{title}';")
     id = movie.first['id']
     title = movie.first['title']
     found_movie = Movie.new({:id => id, :title => title})
   end
   def self.delete(movie)
     DB.exec("DELETE FROM movies WHERE id = '#{movie.id}';")
   end

   def ==(another_movie)
     self.title() && another_movie.title()
   end
end
