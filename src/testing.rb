require "httparty"
require "tty-prompt"
require "dotenv/load"
require "time"
require "json"
require "colorize"
prompt = TTY::Prompt.new
api_key = ENV["api_key"]


response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=30.4898&lon=-99.7713&exclude=minutely&units=metric&appid=#{api_key}").parsed_response

puts "This is blue".colorize(:cyan)
puts "This is light blue".colorize(:light_magenta)
puts "This is also blue".colorize(:color => :light_yellow)
puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)
puts "This is light blue with red background".colorize(:light_blue ).colorize( :background => :red)
puts "This is blue text on red".blue.on_red
puts "This is red on blue".colorize(:red).on_blue
puts "This is red on blue and underline".colorize(:red).on_blue.underline
puts "This is blue text on red".blue.on_red.blink
puts "This is uncolorized".blue.on_red.uncolorize