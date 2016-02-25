require 'rubygems'
require 'bundler/setup'
Bundler.require
require './model/menu.rb'
require './model/recipe.rb'
require './model/word.rb'
ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  "db/recipe.sqlite"
)
