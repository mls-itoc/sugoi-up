require './app'
require 'csv'

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "db/recipe.sqlite"
)

class Menu < ActiveRecord::Base
end

Menu.destroy_all #menusテーブルを空にする

CSV.foreach("data/menus.csv") do |row| #menus.csvの内容をすべてテーブルにInsertする
  code = row[0].split("_")[1] #"category_"の部分は使用しない
  Menu.create(rakuten_code: code, name: row[1])
end
