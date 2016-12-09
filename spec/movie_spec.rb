require('spec_helper')

describe(Movie) do
  before() do
    @movie1 = Movie.new({:id => nil, :title => "Die Hard"})
    @movie2 = Movie.new({:id => nil, :title => "Snakes on a Plane"})
    @movie3 = Movie.new({:id => nil, :title => "Peter Pan"})


  end
  describe('.all') do
    before () do
      DB.exec("DELETE FROM movies *;")
    end
    it('returns an empty array if no movies exist') do
      expect(Movie.all).to(eq([]))
    end
  end
  describe('#title') do
    it('returns the title of an movie') do
      expect(@movie1.title).to(eq('Die Hard'))
    end
  end
  describe('#id') do
    it('returns the id of an movie') do
      @movie1.save
      expect(@movie1.id).to be_an_instance_of(Fixnum)
    end
  end
  describe('#==') do
    it("returns true when two objects attributes are the same") do
      movie3  = Movie.new({:id => nil, :title => "Die Hard"})
      expect(@movie1).to(eq(movie3))
    end
  end
  describe('.find_by_id') do
    it("returns an movie object based on its id") do
      @movie1.save
      expect(Movie.find_by_id(@movie1.id)).to(eq(@movie1))
    end
  end
  describe('.find_by_title') do
    it("returns an movie object based on its title") do
      @movie1.save
      expect(Movie.find_by_title(@movie1.title)).to(eq(@movie1))
    end
  end
  describe('.delete') do
    it("deletes an object") do
      @movie1.save
      Movie.delete(@movie1)
      expect(Movie.all).to(eq([]))
    end
  end
  describe('#update') do
    it("updates an movies title") do
      @movie1.save
      @movie1.update({:title => 'Happy Gilmore girls'})
      expect(@movie1.title).to(eq('Happy Gilmore girls'))
    end
  end
  describe('#actors') do
    it("adds an actor to a movie") do
      @movie4  = Movie.new({:id => nil, :title => "Die Hard with a Vengeance"})
      @movie4.save
      actor1 = Actor.new(:id => nil, :name => "Bruce Willis")
      actor1.save
      actor2 = Actor.new(:id => nil, :name => "Samuel L Jackson")
      actor2.save
      @movie4.update(:actor_ids => [actor1.id, actor2.id])
      expect(@movie4.actors).to(eq([actor1, actor2]))
    end
  end

  describe('#current_renter') do
    it("shows which movies a customer currently has") do
      customer1 = Customer.new({:id => nil, :name => "James"})
      customer1.save
      @movie1.save
      @movie2.save
      customer1.checkout(:movie_ids => [@movie1.id, @movie2.id])
      expect(@movie1.current_renter[0].name).to(eq('James'))
    end
  end
  describe('#in_stock') do
    it("only returns movies that are not checked out") do
      customer1 = Customer.new({:id => nil, :name => "James"})
      customer1.save
      @movie3.save
      customer1.checkout(:movie_ids => [@movie3.id])
      expect(Movie.in_stock).to_not(include(@movie3))
    end
  end
  describe('#in_stock') do
    it("returns all movies that are not checked out") do
      customer1 = Customer.new({:id => nil, :name => "James"})
      customer1.save
      movie4 = Movie.new({:id => nil, :title => "Snow White"})
      movie4.save
      expect(Movie.in_stock).to(include(movie4))
    end
  end
end
