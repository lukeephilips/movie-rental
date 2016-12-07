require('rspec')
require('pry-nav')
require('actor')
require('movie')
require('customer')
require('pg')

DB = PG.connect ({:dbname => 'rentals_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM customer *;")
    DB.exec("DELETE FROM movies *;")
    DB.exec("DELETE FROM actors *;")
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM movies_actors *;")
  end
end
