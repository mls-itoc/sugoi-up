require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'uri'
require './model/menu.rb'
require './model/recipe.rb'
require 'open-uri'
require 'fileutils'


i = nil
limit_flg = false
unless ARGV[0] == nil
  i = (ARGV[0].to_i)*2
  limit_flg = true
  page_n = (i / 5)+1
end

options = {
  :delay => 1,
  :depth_limit => page_n
}

words = Menus.all

words.each do |word|
  j = i
  puts word.name
  puts word.crawl_status
  unless word.completed?
    recipe = URI.escape(word.name)
    code = word.rakuten_code
    word.start!
    
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
          unless j <= 0 &&  limit_flg
            j -= 1
            recipe_id = recipe_url.match(/(\d+)\z/)[1] #url末尾から保存用のIDを取得する
            unless FileTest.exist?(File.expand_path("../data/#{code}/#{recipe_id}.html", __FILE__))
            p page.url.to_s
              unless Dir.exist?(File.expand_path("../data/#{code}/", __FILE__))
                mkdir(File.expand_path("../data/#{code}/", __FILE__))
              end
          
              open(recipe_url) do |uri|
            
                File.open(File.expand_path("../data/#{code}/#{recipe_id}.html", __FILE__), 'w') do |html|
                  html.puts(uri.read)
                end
                get_image(code,recipe_id)
              end
            end
            if j <= 0
              page_flg = true
            end
            sleep options[:delay]
          end
        end
      end
    end
    word.compl!
    puts word.crawl_status
  end
end