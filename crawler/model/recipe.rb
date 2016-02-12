
def get_image(code,recipe_id)#HTMLファイルから画像の取得保存
  image_url = Nokogiri::HTML.parse(File.open(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__)))
  image_url = image_url.css('//img[data-track-label="Main Photo"]/@data-large-photo').to_s
              
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
                
  image_available = FileTest.exist?(file_path)
                    
  #テーブルに挿入
  Recipes.create(:cookpad_code => recipe_id,:image_available => image_available,:image_file_name => file_path)

end

def get_html(page,code,recipe_id,recipe_url)#HTMLを保存する
  p page.url.to_s
  unless Dir.exist?(File.expand_path("../../data/#{code}/", __FILE__))
    mkdir(File.expand_path("../../data/#{code}/", __FILE__))
  end
          
  open(recipe_url) do |uri|
    File.open(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__), 'w') do |html|
      html.puts(uri.read)
    end
  end
end
