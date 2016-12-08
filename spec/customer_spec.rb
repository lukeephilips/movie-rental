require('spec_helper')

describe(Customer) do
  before() do
    @customer1 = Customer.new({:id => nil, :name => "Billy"})
    @customer2 = Customer.new({:id => nil, :name => "Horst"})

  end
  describe('.all') do
    before () do
      DB.exec("DELETE FROM customer *;")
    end
    it('returns an empty array if no customers exist') do
      expect(Customer.all).to(eq([]))
    end
  end
  describe('#name') do
    it('returns the name of an customer') do
      expect(@customer1.name).to(eq('Billy'))
    end
  end
  describe('#id') do
    it('returns the id of an customer') do
      @customer1.save
      expect(@customer1.id).to be_an_instance_of(Fixnum)
    end
  end
  describe('#==') do
    it("returns true when two objects attributes are the same") do
      customer3  = Customer.new({:id => nil, :name => "Billy"})
      expect(@customer1).to(eq(customer3))
    end
  end
  describe('.find_by_id') do
    it("returns an customer object based on its id") do
      @customer1.save
      expect(Customer.find_by_id(@customer1.id)).to(eq(@customer1))
    end
  end
  describe('.find_by_name') do
    it("returns an customer object based on its name") do
      @customer1.save
      expect(Customer.find_by_name(@customer1.name)).to(eq(@customer1))
    end
  end
  describe('.delete') do
    it("deletes an object") do
      @customer1.save
      Customer.delete(@customer1)
      expect(Customer.all).to(eq([]))
    end
  end
  describe('#update') do
    it("updates an customers name") do
      @customer1.save
      @customer1.checkout(:name => 'Big Willy')
      expect(@customer1.name).to(eq('Big Willy'))
    end
  end

  describe("#checkout") do
    it("allows a customer to checkout a movie") do
      @customer1.save
      movie1 = Movie.new({:id => nil, :title => "Die Hard"})
      movie2 = Movie.new({:id => nil, :title => "Snakes on a Plane"})
      movie1.save
      movie2.save
      @customer1.checkout(:movie_ids => [movie1.id, movie2.id])
      expect(@customer1.movies[0].title).to(eq('Die Hard'))
    end
  end
  describe("#movies") do
    it("allows a customer to view their current movies checked out") do
      @customer1.save
      movie1 = Movie.new({:id => nil, :title => "Die Hard"})
      movie2 = Movie.new({:id => nil, :title => "Snakes on a Plane"})
      movie1.save
      movie2.save
      @customer1.checkout(:movie_ids => [movie1.id, movie2.id])
      expect(@customer1.movies).to(eq([movie1, movie2]))
    end
  end
  describe("#movies") do
    it("allows a customer to view their current movies checked out") do
      @customer1.save
      movie1 = Movie.new({:id => nil, :title => "Die Hard"})
      movie2 = Movie.new({:id => nil, :title => "Snakes on a Plane"})
      movie1.save
      movie2.save
      @customer1.checkout(:movie_ids => [movie1.id, movie2.id])
      @customer1.return(:movie_ids => [movie1.id, movie2.id])
      expect(@customer1.movies).to(eq([]))
    end
  end
end
