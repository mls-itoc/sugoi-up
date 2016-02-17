class Recipe < ActiveRecord::Base
  belongs_to :menu

  def self.get_image(code, recipe_id, menu)#HTMLファイルから画像の取得保存
    image_html = Nokogiri::HTML.parse(File.open(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__)))
    image_url = image_html.css('//img[data-track-category="Recipe Large Photo"]/@data-large-photo').to_s

    recipe = Recipe.new(cookpad_code: recipe_id)
    recipe.menu = menu

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

      recipe.image_available = true
      recipe.image_file_name = file_path
      recipe.save
    else
      recipe.image_available = false
      recipe.save
      File.unlink(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__))
      puts "skip"
    end
  end

  def self.get_html(code,recipe_id,recipe_url)#HTMLを保存する
    unless Dir.exist?(File.expand_path("../../data/#{code}/", __FILE__))
      Dir.mkdir(File.expand_path("../../data/#{code}/", __FILE__))
    end

    open(recipe_url) do |uri|
      File.open(File.expand_path("../../data/#{code}/#{recipe_id}.html", __FILE__), 'w') do |html|
        html.puts(uri.read)
      end
    end
  end

end
