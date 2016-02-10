require 'active_record'


ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "recipe.sqlite"
)

class Menus < ActiveRecord::Base
end

class Recipes < ActiveRecord::Base
end

class Job
  include AASM

  aasm do
    state :sleeping, :initial => :waiting
    state :running, :initial => :crawling
    state :cleaning, :initial => :completed

    event :run do
      transitions :from => :sleeping, :to => :running
    end

    event :clean do
      transitions :from => :running, :to => :cleaning
    end

    event :sleep do
      transitions :from => [:running, :cleaning], :to => :sleeping
    end
  end

end
