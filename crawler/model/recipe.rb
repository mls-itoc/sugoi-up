
def get_image(code,recipe_id)#HTMLファイルから画像の取得保存
  image_html = Nokogiri::HTML.parse(File.open(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__)))
  image_url = image_html.css('//img[data-track-category="Recipe Large Photo"]/@data-large-photo').to_s
  
  unless image_url == ""
    name = image_url.rpartition("/")
    name = name[2].rpartition("?")
    file_name = File.basename(name[0])
    dir_name = File.expand_path("../../data/images/#{code}/", __FILE__)
    file_path = dir_name + "/" + file_name
                
    FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
    
    open(file_path, 'wb') do |output|
      open(image_url) do |data|
        output.write(data.read)
      end
    end
    
    Recipes.create(:cookpad_code => recipe_id,:image_available => true,:image_file_name => file_path)
  else
    Recipes.create(:cookpad_code => recipe_id,:image_available => false,:image_file_name => nil)
    File.unlink(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__)) 
    puts "skip"
  end
end

def get_html(code,recipe_id,recipe_url)#HTMLを保存する
  unless Dir.exist?(File.expand_path("../../data/#{code}/", __FILE__))
    Dir.mkdir(File.expand_path("../../data/#{code}/", __FILE__))
  end
          
  open(recipe_url) do |uri|
    File.open(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__), 'w') do |html|
      html.puts(uri.read)
    end
  end
end
