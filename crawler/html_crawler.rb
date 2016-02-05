require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'uri'

options = {
  :delay => 1#,
  # :depth_limit => 0
}

words = ['ハンバーグ']

words.each do |word|
  recipe = URI.escape(word)

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
        recipe_urls << href if href.match(/\/recipe\/\d+\z/)
      end

      recipe_urls.each do |recipe_url|
        recipe_id = recipe_url.match(/(\d+)\z/)[1]
        p recipe_id
        open(recipe_url) do |uri|
          File.open(File.expand_path("../data/#{recipe_id}.html", __FILE__), 'w') do |html|
            html.puts(uri.read)
          end
        end
        sleep options[:delay]
      end

    end

  end
end
