class CreateRecipeNames < ActiveRecord::Migration
  def change
    create_table :schoolbooks do |t|
      t.rakuten_code :string
      t.string :name
      t.crawl_status :name

      t.timestamps null: false
    end
  end
end
