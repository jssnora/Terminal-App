require "httparty"
require "tty-prompt"
require "dotenv/load"
require "time"
require "json"
prompt = TTY::Prompt.new
api_key = ENV["api_key"]

# class Weather
#     attr_accessor "dt", "min", "max", "description"
#     def initialize(hash)
#         self.

def forecast
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=30.489772&lon=-99.771335&exclude=minutely,current,hourly,alerts&units=metric&appid=#{api_key}").parsed_response
    daily_weather = Array.new
    for day in response['daily']
        weather_info = Array.new
        weather_info.push(Time.at(day["dt"]).strftime("%A %d/%m/%Y"))
        weather_info.push(day["weather"][0]["description"].capitalize)
        weather_info.push(day["weather"][0]["icon"])
        weather_info.push(day["temp"]["max"].to_s + " degrees")
        weather_info.push(day["temp"]["min"].to_s + " degrees")
        weather_info.push((day["pop"]*100).to_s + "% chance of rain")
        daily_weather.append(weather_info)
    end
    p daily_weather
end

def get_weather_data
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=30.489772&lon=-99.771335&exclude=minutely,current,hourly,alerts&units=metric&appid=#{api_key}").parsed_response
end

p get_weather_data

response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=30.489772&lon=-99.771335&exclude=minutely,current,hourly,alerts&units=metric&appid=#{api_key}").parsed_response


# p Time.at(response["daily"][0]["dt"]).strftime("%A %d/%m/%Y")

# File.write('./weather-data.json', JSON.dump(response))
# .strftime(%A %d/%m/%Y)

