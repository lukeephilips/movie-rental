class Actor
  attr_reader(:id, :name)
  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
  end
  def self.all
    returned_actors = DB.exec("SELECT * FROM actors;")
    actors = []
    returned_actors.each do |actor|
      id = actor['id']
      name = actor['name']
      actors.push(Actor.new({:id => id, :name => name}))
    end
    actors
  end
  def save
    result = DB.exec("INSERT INTO actors (name) VALUES ('#{@name}') RETURNING id;")
     @id = result[0]['id'].to_i
   end

   def ==(another_actor)
     self.name() && another_actor.name()
   end
end
