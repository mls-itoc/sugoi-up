#! /bin/sh
exec ruby -S -x "$0" "$@"
#! ruby

require File.expand_path('../app', __FILE__)

puts Menu.find_by(id: ARGV[0]).name
