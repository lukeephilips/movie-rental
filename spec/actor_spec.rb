require('spec_helper')

describe(Actor) do
  before() do
    @actor1 = Actor.new({:id => nil, :name => "Bruce Willis"})
    @actor2 = Actor.new({:id => nil, :name => "Samuel L Jackson"})

  end
  describe('.all') do
    it('returns an empty array if no actors exist') do
      expect(Actor.all).to(eq([]))
    end
  end
  describe('#name') do
    it('returns the name of an actor') do
      expect(@actor1.name).to(eq('Bruce Willis'))
    end
  end
  describe('#id') do
    it('returns the id of an actor') do
      @actor1.save
      expect(@actor1.id).to be_an_instance_of(Fixnum)
    end
  end
  describe('#==') do
    it("returns true when two objects attributes are the same") do
      actor3  = Actor.new({:id => nil, :name => "Bruce Willis"})
      expect(@actor1).to(eq(actor3))
    end
  end
  describe('.find_by_id') do
    it("returns an actor object based on its id") do
      @actor1.save
      expect(Actor.find_by_id(@actor1.id)).to(eq(@actor1))
    end
  end
  describe('.find_by_name') do
    it("returns an actor object based on its name") do
      @actor1.save
      expect(Actor.find_by_name(@actor1.name)).to(eq(@actor1))
    end
  end
  describe('.delete') do
    it("deletes an object") do
      @actor1.save
      Actor.delete(@actor1)
      expect(Actor.all).to(eq([]))
    end
  end
end
