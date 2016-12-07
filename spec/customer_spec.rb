require('spec_helper')

describe(Customer) do
  before() do
    @customer1 = Customer.new({:id => nil, :name => "Billy"})
    @customer2 = Customer.new({:id => nil, :name => "Horst"})

  end
  describe('.all') do
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
end
