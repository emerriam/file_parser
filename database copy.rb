require 'sqlite3'
require 'active_record'

# Set up a database that resides in RAM
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Set up model classes
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
class ExampleTable < ApplicationRecord
end
