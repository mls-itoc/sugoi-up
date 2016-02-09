require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "./recipe.sqlite"
)

ActiveRecord::Base.connection.execute("TRUNCATE menus")#menusテーブルを空にする

CSV.foreach("data/menus.csv") do |row|
  code
  ActiveRecord::Base.connection.execute("INSERT INTO menus(rakuten_code,name,crawl_status) VALUES('#{code}', '#{row[1]}',#{:waiting});")
end

