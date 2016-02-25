require './app'
require 'open-uri'
require 'csv'

array_data = [] # 最終的にほしいデータがここに入る

doc = Nokogiri::HTML(open "http://recipe.rakuten.co.jp/category/") # 楽天レシピのカテゴリ一覧ページ
categoryListBoxes = doc.css('.categoryListBox')
categoryListBoxes.each do |categoryListBox|
  atags = categoryListBox.css('[sctag]') # sctag属性のあるノードを抽出
  atags.each do |atag|
    attribute = atag.get_attribute('sctag')
    if match_data = attribute.match(/\Acategory_\d+\-\d+(\-\d+)?\z/) # 3階層あるカテゴリの第2、第3階層のみ抽出
      array_data << {
        category: match_data[0], # これがcategory_xx-xxx(-xxx) の部分
        recipe: atag.text        # これが「肉じゃが」みたいな部分
      }
    end
  end
end
array_data.uniq!
# ↑この時点で
# array_data[0]
# => {:category=>"category_30-302", :recipe=>"肉じゃが"}
# のようになっている

# たとえばカテゴリ第2階層「肉じゃが」にはさらに下の第3階層が存在しないので、これをそのままレシピ名称として生かす
# 他方、第2階層「ハンバーグ」には第3階層「ハンバーグステーキ」「煮込みハンバーグ」などが存在するので、レシピ名称「ハンバーグ」は意味的に他と重複（他を包括）してしまう
# したがって「第3階層を持つ第2階層カテゴリ」を削除する
second_categories_in_third_categories = array_data.select do |datum|  # 第3階層のカテゴリコードだけを集め、そのなかの第2階層を取り出す
  datum[:category].match(/\Acategory_\d+\-\d+-\d+\z/)
end.map{ |datum| datum[:category] }.map{ |datum| datum.match(/\Acategory_\d+\-\d+/)[0] }.uniq
array_data.delete_if do |datum| # 「第3階層を持つ第2階層カテゴリ」を削除する
  second_categories_in_third_categories.include?(datum[:category])
end

# 類似カテゴリの各かたまりの最後に「その他xxx」というのがある。消したい
# それ以外にも明らかに使えなさそうなものをザクザク削除
filterd_words = /(\Aその他|のお弁当|ソース\z|のたれ\z|合うタレ\z|ドレッシング\z|コーヒー\z|ジュース\z|ドリンク\z|おつまみ\z|の献立\z|簡単.*料理|多い食品の料理\z|多いレシピ\z|離乳食|幼児食|圧力鍋で作る|シリコンスチーマーで作る|炊飯器で作る|電子レンジで作る|ホーロー鍋で作る|おもてなし料理\z|アレルギー）\z|を使わない\(料理\)?\z)/
array_data.delete_if do |datum|
  datum[:recipe].match(filterd_words)
end

# 結果をcsvに書き出す
# まだ削除すべきものはたくさん含まれるが、手で消すことにする
CSV.open(File.expand_path('../data/menus.csv', __FILE__), 'w') do |recipes|
  array_data.each do |datum|
    recipes << [datum[:category], datum[:recipe]]
  end
end
