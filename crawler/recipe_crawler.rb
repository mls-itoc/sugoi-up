require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'uri'
require './model/menu.rb'

require 'open-uri'
require 'fileutils'

i = nil
if ARGV[0]
  i = ARGV[0].to_i
end

options = {
  :delay => 1,
  :depth_limit => i
}

words = Menus.all

words.each do |word|
  recipe = URI.escape(word.name)
  code = word.rakuten_code

  Anemone.crawl("http://cookpad.com/search/#{recipe}", options) do |anemone| 

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
        if Dir.exist?(File.expand_path("../data/#{code}/", __FILE__))== false
          mkdir(File.expand_path("../data/#{code}/", __FILE__))
        end
        
        open(recipe_url) do |uri|
          
          File.open(File.expand_path("../data/#{code}/#{recipe_id}.html", __FILE__), 'w') do |html|
            html.puts(uri.read)
          end
           #画像の保存
          image_url = Nokogiri::HTML.parse(File.open(File.expand_path("../data/#{code}/#{recipe_id}.html", __FILE__)))
          image_url = image_url.css('//img[data-track-label="Main Photo"]/@data-large-photo').to_s
          puts image_url
          
          name = image_url.rpartition("/")
          name = name[2].rpartition("?")
          file_name = File.basename(name[0])
          dir_name = File.expand_path("../data/images/#{code}/", __FILE__)
          file_path = dir_name + file_name
        
          FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
            open(file_path, 'wb') do |output|
              open(image_url) do |data|
                output.write(data.read)
              end
            end
            
            if FileTest.exist?(dir_name)
              image_available = true
            else
              image_available = false
            end
            
            #テーブルに挿入
            Recipes.create(:cookpad_code => recipe_id,:image_available => image_available,:image_file_name => file_path)
          end
        sleep options[:delay]
      end
    end
  end
end
