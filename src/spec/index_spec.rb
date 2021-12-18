require_relative '../index.rb'

describe 'get weather data' do
    it 'should return a hash' do
        weather_data = get_weather_data()
        expect(weather_data).to be_kind_of(Hash)
    end

    it 'should return a hash' do
        weather_data = get_weather_data()
        expect(weather_data['cod'].to_i).to be('404')
    end

end

describe 'format_seven_day_data' do
    it 'should return a hash' do
        expect(format_seven_day_data()).to be_kind_of(Hash)
    end

    it 'should return a hash' do
        expect(format_seven_day_data().length).to be(8)
    end

end