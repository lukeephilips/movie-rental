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
  describe('#update_name') do
    it("updates an customers name") do
      @customer1.save
      @customer1.update_name(:name => 'Big Willy')
      expect(@customer1.name).to(eq('Big Willy'))
    end
  end
end
