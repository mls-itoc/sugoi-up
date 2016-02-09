require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "recipe.sqlite"
)

class Menus < ActiveRecord::Base
end

