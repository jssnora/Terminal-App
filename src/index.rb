require "httparty"
require "tty-prompt"
prompt = TTY::Prompt.new

def change_city
    prompt = TTY::Prompt.new
    search_method = prompt.select("Please choose an option:", ["Search by city name", "Search by postcode"])
    
    case search_method
    when "Search by city name"
        city_name = prompt.ask("Please enter a city name", required: true) do |q|
            q.modify :strip, :down
        end
        city_name.gsub!(" ", "+")
        puts city_name
    when "Search by postcode"
        postcode = prompt.ask("Please enter a postcode", convert: :integer) do |q|
            q.validate(/^[0-9]{4}$/)
            q.messages[:valid?] = "Invalid postcode. Please enter a valid 4-digit Australian postcode"
        end
    end
end

change_city

exit_chosen = false
while !exit_chosen
    choices = ["Change city", "Today's weather", "7 Day forecast" , "Exit"]
    menu_selection = prompt.select("Please choose an option:", choices)
    case menu_selection
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




