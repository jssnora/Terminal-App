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


