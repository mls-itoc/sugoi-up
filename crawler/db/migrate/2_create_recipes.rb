class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :schoolbooks do |t|
      t.references :recipe_name, index: true
      t.integer :cookpad_code
      t.image_available :boolean
      t.image_file :string

      t.timestamps null: false
    end
  end
end
