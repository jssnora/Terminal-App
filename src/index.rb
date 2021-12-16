require "httparty"
require "tty-prompt"
require "tty-table"
require "dotenv/load"
require "json"
prompt = TTY::Prompt.new
api_key = ENV["api_key"]

$city_name = nil
$latitude = nil
$longitude = nil

def validate_city(city)
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=#{city},au&units=metric&appid=#{api_key}").parsed_response

    if response["cod"].to_i == 200
        $city_name = city
        $latitude = response["coord"]["lat"]
        $longitude = response["coord"]["lon"]
    elsif response["cod"].to_i == 404
        puts "ERROR - City not found. Please enter a valid Australian city name"
    else
        puts "Some error has occurred, please try again."
    end
end

def validate_postcode(postcode)
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?zip=#{postcode},au&units=metric&appid=#{api_key}").parsed_response

    if response["cod"].to_i == 200
        associated_city = response["name"].downcase.gsub(" ", "+")
        $city_name = associated_city
        $latitude = response["coord"]["lat"]
        $longitude = response["coord"]["lon"]
    elsif response["cod"].to_i == 404 || 400
        puts "ERROR - Postcode not found. Please enter a valid Australian postcode"
    else
        puts "Some error has occurred, please try again."
    end
end

def change_city
    prompt = TTY::Prompt.new
    search_method = prompt.select("Please choose an option to view the weather:", ["Search by city name", "Search by postcode"])
    
    case search_method
    when "Search by city name"
        input_city_name = prompt.ask("Please enter a city name:", required: true) do |q|
            q.modify :strip, :down
        end
        input_city_name.gsub!(" ", "+")
        validate_city(input_city_name)
    when "Search by postcode"
        input_postcode = prompt.ask("Please enter a postcode:", convert: :integer, required: true) do |q|
            q.validate(/^[0-9]{4}$/)
            q.messages[:valid?] = "Invalid postcode. Please enter a valid 4-digit Australian postcode"
        end
        validate_postcode(input_postcode)
    end
end

def seven_day_forecast
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=#{$latitude}&lon=#{$longitude}&exclude=minutely&units=metric&appid=#{api_key}").parsed_response
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
end

exit_chosen = false
while !exit_chosen
    if !$city_name
        choices = ["Select city", {name: "Today's weather", disabled: "(Please select a city to view weather)"}, {name: "7 Day forecast", disabled:"(Please select a city to view weather)" }, "Exit"]
    else
        choices = ["Change city", "Today's weather", "7 Day forecast" , "Exit"]
    end
    
    menu_selection = prompt.select("Please choose an option:", choices)
    case menu_selection
    when "Select city"
        change_city
    when "Change city"
        change_city
    when "Today's weather"

        puts "Show today's weather"
    when "7 Day forecast"
        puts "Show 7 day forecast"
    when "Exit"
        exit_chosen = true
    end
end




