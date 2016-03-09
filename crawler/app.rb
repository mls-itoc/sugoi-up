require 'rubygems'
require 'bundler/setup'
Bundler.require
require File.expand_path('../model/menu.rb', __FILE__)
require File.expand_path('../model/recipe.rb', __FILE__)
require File.expand_path('../model/word.rb', __FILE__)
ActiveRecord::Base.establish_connection(
  adapter:   'sqlite3',
  database:  File.expand_path('../db/recipe.sqlite', __FILE__)
)
