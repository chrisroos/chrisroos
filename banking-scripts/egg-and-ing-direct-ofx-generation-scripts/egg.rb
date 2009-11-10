#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/egg'

html_file = ARGV.shift
unless html_file and File.exists?(html_file)
  raise "Usage: egg2ofx path/to/egg-html-file"
end

html   = File.open(html_file) { |f| f.read }
parser = Egg::Parser.new(html)

puts parser.to_ofx