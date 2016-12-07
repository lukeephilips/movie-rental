require('spec_helper')

describe(Movie) do
  before() do
    @movie1 = Movie.new({:id => nil, :title => "Die Hard"})
    @movie2 = Movie.new({:id => nil, :title => "Snakes on a Plane"})

  end
  describe('.all') do
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
  describe('#update_title') do
    it("updates an movies title") do
      @movie1.save
      @movie1.update_title(:title => 'Happy Gilmore girls')
      expect(@movie1.title).to(eq('Happy Gilmore girls'))
    end
  end
end
