class AddPoemToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :poem, :text
  end
end
