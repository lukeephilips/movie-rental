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
end
