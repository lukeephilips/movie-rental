
class Actor
  attr_reader(:id, :name)
  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
  end
  def save
    result = DB.exec("INSERT INTO actors (name) VALUES ('#{@name}') RETURNING id;")
     @id = result[0]['id'].to_i
  end
  def update_name(attributes)
    @id = self.id
    @name = attributes[:name]
    DB.exec("UPDATE actors SET name = '#{@name}' WHERE id = #{@id};")
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
  def self.find_by_id(id)
    actor = DB.exec("SELECT * FROM actors WHERE id = #{id};")
    id = actor.first['id']
    name = actor.first['name']
    found_actor = Actor.new({:id => id, :name => name})
  end
  def self.find_by_name(name)
    actor = DB.exec("SELECT * FROM actors WHERE name = '#{name}';")
    id = actor.first['id']
    name = actor.first['name']
    found_actor = Actor.new({:id => id, :name => name})
  end
  def self.delete(actor)
    DB.exec("DELETE FROM actors WHERE id = '#{actor.id}';")
  end

  def ==(another_actor)
    self.name() && another_actor.name()
  end
end
