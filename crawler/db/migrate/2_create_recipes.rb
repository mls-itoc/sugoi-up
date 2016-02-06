class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.references :menu, index: true
      t.integer    :cookpad_code,    comment: '例）http://cookpad.com/recipe/887445の"887445"'
      t.boolean    :image_available, comment: '画像取得に成功したらtrue、失敗したらfalse'
      t.string     :image_file_name, comment: '画像のディレクトリ/ファイル名。data/images/[menus.rakuten_code]/[この部分はGihubのイシューの指示に従うこと]'

      t.timestamps null: false
    end
  end
end
