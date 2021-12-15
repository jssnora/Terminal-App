require "httparty"
require "tty-prompt"
require "dotenv/load"
prompt = TTY::Prompt.new
api_key = ENV["api_key"]

$city_name = ""
$postcode = 0


def change_city
    prompt = TTY::Prompt.new
    search_method = prompt.select("Please choose an option:", ["Search by city name", "Search by postcode"])
    
    case search_method
    when "Search by city name"
        input_city_name = prompt.ask("Please enter a city name:", required: true) do |q|
            q.modify :strip, :down
        end
        $city_name = input_city_name.gsub!(" ", "+")
        $postcode = nil
    when "Search by postcode"
        input_postcode = prompt.ask("Please enter a postcode:", convert: :integer) do |q|
            q.validate(/^[0-9]{4}$/)
            q.messages[:valid?] = "Invalid postcode. Please enter a valid 4-digit Australian postcode"
        end
        $postcode = input_postcode
        $city_name = nil
    end
end

def validate_city
    api_key = ENV["api_key"]
    if $postcode == nil
        response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=#{$city_name},au&units=metric&appid=#{api_key}")
        if response.parsed_response["cod"] == 404
            puts "ERROR - City not found. Please enter a valid Australian city name"
            change_city
        else
            true
        end
    elsif $city_name == nil 
        response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?zip=#{$postcode},au&units=metric&appid=#{api_key}")
        if response.parsed_response["cod"] == 404
            puts "ERROR - Postcode not found. Please enter a valid Australian postcode"
            change_city            
        else
            $city_name = response.parsed_response["name"].downcase
            true
        end
    else
        puts "Some error has occurred, try again"
    end
end

change_city
p validate_city
p $city_name

# response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=#{$city_name},au&units=metric&appid=#{api_key}")

# p response
# exit_chosen = false
# while !exit_chosen
#     choices = ["Change city", "Today's weather", "7 Day forecast" , "Exit"]
#     menu_selection = prompt.select("Please choose an option:", choices)
#     case menu_selection
#     when "Change city"
#         change_city
#     when "Today's weather"
#         puts "Show today's weather"

#     when "7 Day forecast"
#         puts "Show 7 day forecast"
#     when "Exit"
#         exit_chosen = true
#     end
# end