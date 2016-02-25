require './app'
require 'uri'
require 'open-uri'
require 'fileutils'

File.open('./data/train.txt', 'w') do |traintxt|
  Recipe.where(image_available: true).find_each do |recipe|
    traintxt.puts "#{recipe.image_file_name} #{recipe.menu_id}"
  end
end
