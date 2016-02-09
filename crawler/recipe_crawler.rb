require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'uri'
require './model/menu.rb'

options = {
  :delay => 1#,
  # :depth_limit => 0
}

words = Menus.all

words.each do |word|
  recipe = URI.escape(word.name)
  code = word.rakuten_code

  Anemone.crawl("http://cookpad.com/search/#{recipe}", options) do |anemone| #検索結果ページ

    anemone.focus_crawl do |page|
      page.links.keep_if { |link|
        link.to_s.match(%r[\/search/#{recipe}\?page=\d+&recipe_hit])
      }
    end

    anemone.on_every_page do |page|
      p page.url.to_s
      recipe_urls = []
      doc = Nokogiri::HTML.parse(page.body)
      atags = doc.css('a')
      atags.each do |atag|
        href = atag.get_attribute('href')
        recipe_urls << href if href.match(/\/recipe\/\d+\z/) #結果のレシピページを探す
      end

      recipe_urls.each do |recipe_url|
        recipe_id = recipe_url.match(/(\d+)\z/)[1] #url末尾から保存用のIDを取得する
        p recipe_id
        #puts File::expand_path('.')
        if Dir.exist?(File.expand_path("../data/#{code}/", __FILE__))== false
          mkdir(File.expand_path("../data/#{code}/", __FILE__))
        end
        
        open(recipe_url) do |uri|
          
          
          File.open(File.expand_path("../data/#{code}/#{recipe_id}.html", __FILE__), 'w') do |html|
            html.puts(uri.read)
          end
        end
        sleep options[:delay]
      end

    end

  end
end
