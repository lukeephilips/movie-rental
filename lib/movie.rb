class Movie
  attr_reader(:id, :title)
  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
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
  def save
    result = DB.exec("INSERT INTO movies (title) VALUES ('#{@title}') RETURNING id;")
     @id = result[0]['id'].to_i
   end

   def ==(another_movie)
     self.title() && another_movie.title()
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
end
