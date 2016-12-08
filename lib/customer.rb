class Customer
  attr_reader(:id, :name)
  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
  end
  def save
    result = DB.exec("INSERT INTO customer (name) VALUES ('#{@name}') RETURNING id;")
     @id = result[0]['id'].to_i
   end
   def update_name(attributes)
     @id = self.id
     @name = attributes[:name]
     DB.exec("UPDATE customer SET name = '#{@name}' WHERE id = #{@id};")
   end

  def checkout(attributes)
    @id = self.id
    @name = attributes.fetch(:name, @name)

    attributes.fetch(:movie_ids, []).each() do |movie_id|
      DB.exec("INSERT INTO checkouts (movie_id, customer_id) VALUES (#{movie_id}, #{self.id});")
    end
  end

  def movies
    checkouts = []
    results = DB.exec("SELECT movie_id FROM checkouts WHERE customer_id = #{self.id};")
    results.each do |result|
      movie_id = result.fetch("movie_id").to_i
      movie = DB.exec("SELECT * FROM movies WHERE id = #{movie_id};")
      title = movie.first.fetch("title")
      new_movie = Movie.new(:title => title, :id => movie_id)
      checkouts.push(new_movie)
    end
    checkouts
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
   def self.find_by_id(id)
     customer = DB.exec("SELECT * FROM customer WHERE id = #{id};")
     id = customer.first['id']
     name = customer.first['name']
     found_customer = Customer.new({:id => id, :name => name})
   end
   def self.find_by_name(name)
     customer = DB.exec("SELECT * FROM customer WHERE name = '#{name}';")
     id = customer.first['id']
     name = customer.first['name']
     found_customer = Customer.new({:id => id, :name => name})
   end
   def self.delete(customer)
     DB.exec("DELETE FROM customer WHERE id = '#{customer.id}';")
   end


   def ==(another_customer)
     self.name() && another_customer.name()
   end
end
