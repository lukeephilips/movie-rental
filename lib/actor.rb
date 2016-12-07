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
end
