class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :rakuten_code, comment: '"30-302"や"30-300-1130"など楽天レシピのカテゴリコード'
      t.string :name,         comment: '「肉じゃが」「ハンバーグステーキ」などの料理名称'
      t.string :crawl_status, comment: 'gem "aasm"を利用して状態を管理する。 :waiting -> :crawling -> :completed 。:waitingを初期値（initial）とすること'

      t.timestamps null: false
    end
  end
end
