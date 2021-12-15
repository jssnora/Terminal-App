require "httparty"
require "tty-prompt"
require "dotenv/load"
prompt = TTY::Prompt.new
api_key = ENV["api_key"]

def change_city
    prompt = TTY::Prompt.new
    search_method = prompt.select("Please choose an option to view the weather:", ["Search by city name", "Search by postcode", "Exit"])
    
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
    when "Exit"
        exit_chosen = true
    end
end

exit_chosen = false
while !$city_name
    change_city
end