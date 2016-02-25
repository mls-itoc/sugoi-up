class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.references :menu, index: true
      t.string     :word, comment: '単語'
      t.string     :part_of_speech, comment: '品詞'

      t.timestamps null: false
    end
  end
end
