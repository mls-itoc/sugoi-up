require 'active_record'


ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "db/recipe.sqlite"
)

class Menus < ActiveRecord::Base
  include AASM
  
  aasm :column => :crawl_status do
    state :waiting, :initial => true
    state :crawling
    state :completed
  
    event :start do
      transitions [:from,:crawling] => :waiting, :to => :crawling
    end
  
    event :compl do
      transitions :from => :crawling, :to => :completed
    end

  end
end

class Recipes < ActiveRecord::Base
end
