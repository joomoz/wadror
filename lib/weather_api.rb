class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    Rails.cache.fetch("#{city}weather", expires_in: 2.minutes, race_condition_ttl: 15) { fetch_weather_in(city) }
  end

  def self.fetch_weather_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q="
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    return nil if response.code != 200 or response.parsed_response['error'] and response.parsed_response['error'].any?
    Weather.new(response)
  end

  def self.key
    raise "APIKEY env variable not defined" if not ENV['APIXU_API_KEY']
    ENV['APIXU_API_KEY']
  end
end
