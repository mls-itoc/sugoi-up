#! /bin/sh
exec ruby -S -x "$0" "$@"
#! ruby

require "#{ARGV[1] || '.'}/app"

puts Menu.find_by(id: ARGV[0]).name
