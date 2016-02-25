require './app'

# ./data/[楽天コード]/*.html のポエムをsqliteに突っ込むスクリプト

Recipe.where(image_available: true).find_each do |recipe|
  doc = Nokogiri::HTML(File.open "./data/#{recipe.menu.rakuten_code}/#{recipe.cookpad_code}.html")
  recipe.poem = doc.css('.description_text').children.select{|elem| elem.text?}.map(&:text).join("\n").strip
  recipe.save
end
