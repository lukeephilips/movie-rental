class Customer
  attr_reader(:id, :name)
  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
  end
  def self.all
    returned_customers = DB.exec("SELECT * FROM customer;")
    customers = []
    returned_customers.each do |customer|
      id = customer['id']
      name = customer['name']
      customers.push(Customer.new({:id => id, :name => name}))
    end
    customers
  end
  def save
    result = DB.exec("INSERT INTO customer (name) VALUES ('#{@name}') RETURNING id;")
     @id = result[0]['id'].to_i
   end

   def ==(another_customer)
     self.name() && another_customer.name()
   end
end
