require 'active_record'
require 'csv'

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "db/recipe.sqlite"
)

class Menus < ActiveRecord::Base
end

Menus.destroy_all #menusテーブルを空にする

CSV.foreach("data/menus.csv") do |row| #menus.csvの内容をすべてテーブルにInsertする
  code = row[0].split("_")[1] #"category_"の部分は使用しない
  Menus.create(:rakuten_code => code, :name => row[1])
end
