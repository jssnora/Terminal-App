require "httparty"
require "tty-prompt"
require "tty-table"
require "dotenv/load"
require "colorize"

prompt = TTY::Prompt.new

$city_name = nil
$latitude = nil
$longitude = nil

#passes formatted city name through API to check if the city exist. If city exist, set global variables city_name, longitude and latitude to be used for weather data API call.It will also return error msgs if input is invalid.
def validate_city(city) 
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=#{city},au&units=metric&appid=#{api_key}").parsed_response

    if response["cod"].to_i == 200
        $city_name = city
        $latitude = response["coord"]["lat"]
        $longitude = response["coord"]["lon"]
    elsif response["cod"].to_i == 404
        puts "Error - City not found. Please enter a valid Australian city name"
    else
        puts "An API connection error has occurred, please try again."
        p response
    end
end

#similar to validate city method, this method will check if the post code exist. If so, it will set the globle variables. It will also return error msgs if input is invalid.
def validate_postcode(postcode)
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?zip=#{postcode},au&units=metric&appid=#{api_key}").parsed_response

    if response["cod"].to_i == 200
        associated_city = response["name"].downcase.gsub(" ", "+")
        $city_name = associated_city
        $latitude = response["coord"]["lat"]
        $longitude = response["coord"]["lon"]
    elsif response["cod"].to_i == 404 || response["cod"].to_i == 400
        puts "Error - Postcode not found. Please enter a valid Australian postcode"
    else
        p response
        puts "An API connection error has occurred, please try again."
    end
end

#change city method will prompt user to select a city. It also checks and formats user input before passing it through the validate city/postcode methods.
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
            q.convert(:integer, "Error - Number input only. Please enter a valid 4-digit Australian postcode")
            q.validate(/^[0-9]{4}$/)
            q.messages[:valid?] = "Error - Invalid postcode. Please enter a valid 4-digit Australian postcode"
        end
        validate_postcode(input_postcode)
    end
end

#this method retrieves weather data from API using the longitude and latitude variables set by the change city method
def get_weather_data
    api_key = ENV["api_key"]
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/onecall?lat=#{$latitude}&lon=#{$longitude}&exclude=minutely&units=metric&appid=#{api_key}").parsed_response
end

#filters specific info from the API response and formats the data so it can be displayed correctly in the gem TTY table
def format_seven_day_data(response)
    daily_weather = Array.new
    for day in response["daily"]
        weather_info = Array.new
        weather_info.push(Time.at(day["dt"]).strftime("%A %d/%m/%Y"))
        weather_info.push(day["weather"][0]["description"].capitalize)
        weather_info.push(day["temp"]["max"].round(2).to_s + " degrees")
        weather_info.push(day["temp"]["min"].round(2).to_s + " degrees")
        weather_info.push((day["pop"]*100).round(0).to_s + "% chance of rain")
        daily_weather.push(weather_info)
    end
    return daily_weather
end

#similar to the above method
def format_todays_weather_data(response)
    daily_weather = Array.new
    weather_info = Array.new
    today_array = response["daily"][0]
    weather_info.push(Time.at(today_array["dt"]).strftime("%A %d/%m/%Y"))
    weather_info.push(today_array["weather"][0]["description"].capitalize)
    weather_info.push(today_array["temp"]["max"].round(2).to_s + " degrees")
    weather_info.push(today_array["temp"]["min"].round(2).to_s + " degrees")
    weather_info.push(today_array["feels_like"]["day"].round(2).to_s + " degrees")
    weather_info.push((today_array["pop"]*100).round(0).to_s + "% chance of rain")
    weather_info.push(today_array["uvi"])
    weather_info.push(today_array["wind_speed"].to_s + " meter/sec")
    weather_info.push(today_array["humidity"].to_s + " %")
    weather_info.push("Sunrise at " + Time.at(today_array["sunrise"]).strftime("%I:%M%p") + " Sunset at " + Time.at(today_array["sunset"]).strftime("%I:%M%p"))
    daily_weather.push(weather_info)
    return daily_weather
end

seven_day_table_header = ["Date", "Condition", "Max temperature", "Min temperature", "Chance of rain"]
todays_weather_table_header = ["Date", "Condition", "Max temperature", "Min temperature", "Feels like", "Chance of rain", "UV Index", "Wind speed", "Humidity", "Sunrise/sunset time"]

#creates table with formatted data
def table(header_array, data_array)
    table = TTY::Table.new(header_array, data_array)
    puts table.render(:unicode)
end


system "clear" 
puts "
                                                                  
 _____               _         _    _ _ _         _   _           
|_   _|___ ___ _____|_|___ ___| |  | | | |___ ___| |_| |_ ___ ___ 
  | | | -_|  _|     | |   | .'| |  | | | | -_| .'|  _|   | -_|  _|
  |_| |___|_| |_|_|_|_|_|_|__,|_|  |_____|___|__,|_| |_|_|___|_|  
                                                                  

".colorize(:cyan)
exit_chosen = false
while !exit_chosen
    if !$city_name
        choices = ["Select city", {name: "Today's weather", disabled: "(Please select a city to view weather)"}, {name: "7 Day forecast", disabled:"(Please select a city to view weather)" }, "Exit"]
    else
        choices = ["Change city", "Today's weather", "7 Day forecast" , "Exit"]
    end

    menu_selection = prompt.select("Please choose an option to view weather:", choices)
    case menu_selection
    when "Select city"
        change_city
    when "Change city"
        system "clear"
        change_city
    when "Today's weather"
        system "clear"
        response = get_weather_data 
        table_weather_data = format_todays_weather_data(response) 
        table(todays_weather_table_header, table_weather_data)
    when "7 Day forecast"
        system "clear"
        response = get_weather_data 
        table_weather_data = format_seven_day_data(response)
        table(seven_day_table_header, table_weather_data)
    when "Exit"
        exit_chosen = true
    end
end
