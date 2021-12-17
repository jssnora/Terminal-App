require "httparty"
require "tty-prompt"
require "dotenv/load"
require "time"
require "json"
prompt = TTY::Prompt.new
api_key = ENV["api_key"]


response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=30.4898&lon=-99.7713&exclude=minutely&units=metric&appid=#{api_key}").parsed_response

def format_todays_weather_data
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=30.4898&lon=-99.7713&exclude=minutely&units=metric&appid=#{api_key}").parsed_response
    weather_info = Array.new
    today_array = response["daily"][0]
    weather_info.push(Time.at(today_array["dt"]).strftime("%A %d/%m/%Y"))
    weather_info.push(today_array["weather"][0]["description"].capitalize)
    weather_info.push(today_array["temp"]["max"].round(2).to_s + " degrees")
    weather_info.push(today_array["temp"]["min"].round(2).to_s + " degrees")
    weather_info.push(today_array["feels_like"]["day"].round(2).to_s + " degrees")
    weather_info.push((today_array["pop"]*100).round(0).to_s + "% chance of rain")
    weather_info.push(today_array["uvi"])
    weather_info.push(today_array["wind_speed"])
    weather_info.push(today_array["humidity"])
    weather_info.push(today_array["sunrise"], today_array["sunset"])
    return weather_info
end


p format_todays_weather_data

