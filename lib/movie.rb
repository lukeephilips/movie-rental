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
end
