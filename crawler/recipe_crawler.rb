require './app'
require 'uri'
require 'open-uri'
require 'fileutils'

i = nil
page_n = false
limit_flg = false
unless ARGV[0] == nil
  i = (ARGV[0].to_i) * 2
  limit_flg = true
  page_n = (i / 20)
  if (i % 20) == 0
    page_n -= 1
  end
  puts page_n
end

options = {
  delay: 1,
  depth_limit: page_n
}

Menu.find_each do |menu|
  j = i
  puts menu.name
  puts menu.crawl_status
  unless menu.completed?
    recipe = URI.escape(menu.name)
    code = menu.rakuten_code
    menu.start!

    Anemone.crawl("http://cookpad.com/search/#{recipe}", options) do |anemone| #検索結果ページ
      anemone.focus_crawl do |page|#ページ切り替え
        page.links.keep_if { |link|
          link.to_s.match(%r[\/search/#{recipe}\?page=\d+&recipe_hit])
        }
      end

      anemone.on_every_page do |page|

        recipe_urls = []
        doc = Nokogiri::HTML.parse(page.body)
        atags = doc.css('a')
        atags.each do |atag|
          href = atag.get_attribute('href')
          recipe_urls << href if href.match(/\/recipe\/\d+\z/) #結果のレシピ番号を探す
        end
        recipe_urls.each do |recipe_url|
          unless limit_flg &&  j <= 0
            recipe_id = recipe_url.match(/(\d+)\z/)[1] #url末尾から保存用のIDを取得する
            unless FileTest.exist?(File.expand_path("../data/#{code}/#{recipe_id}.html", __FILE__))
              puts recipe_url
              Recipe.get_html(code, recipe_id, recipe_url)#HTMLを保存する
              Recipe.get_image(code, recipe_id, menu)#画像を保存する
            end
            if limit_flg
              j -= 1
            end
            sleep options[:delay]
          end
        end
      end
    end
    menu.compl!
    puts menu.crawl_status
  end
end

