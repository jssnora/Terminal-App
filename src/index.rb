require "httparty"
require "tty-prompt"
prompt = TTY::Prompt.new

search_method = prompt.select("Please choose an option:", ["Search by city name", "Search by postcode"])

case search_method
when "Search by city name"
    # need to look into this
    # prompt.ask("Please enter a city name") do |q|
    #     q.modify :strip, :collapse
    #   end
when "Search by postcode"
    # need to look into this
    # prompt.ask("Please enter a postcode", convert: :integer) do |q|
    #     q.convert(:integer, "Please enter a valid postcode")
    #   end
end

exit_chosen = false
while !exit_chosen
    choices = {"Change city" => 1, "Today's weather" => 2, "7 Day forecast" => 3, "Exit" => 4}
    menu_selection = prompt.select("Please choose an option:", choices)
    case menu_selection
    when 1
        puts "CHANGING CITY PROCESS ..."
    when 2
        puts "Show today's weather"
    when 3
        puts "Show 7 day forecast"
    when 4
        exit_chosen = true
    end
end




