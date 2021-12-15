require "httparty"
require "tty-prompt"
require "dotenv/load"
prompt = TTY::Prompt.new
api_key = ENV["api_key"]

response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=kew,au&units=metric&appid=#{api_key}")

p response.parsed_response["main"]["temp_min"]