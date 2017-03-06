class RatingsJob
  include SuckerPunch::Job

  def perform
    Rails.cache.fetch("top_3_beers", expires_in: 2.minutes, race_condition_ttl: 10) { Beer.top(3) }
    Rails.cache.fetch("top_3_breweries", expires_in: 2.minutes, race_condition_ttl: 10) { Brewery.top(3) }
    Rails.cache.fetch("top_3_styles", expires_in: 2.minutes, race_condition_ttl: 10) { Style.top(3) }
    Rails.cache.fetch("top_3_users", expires_in: 2.minutes, race_condition_ttl: 10) { User.top(3) }
    Rails.cache.fetch("recent_ratings", expires_in: 2.minutes, race_condition_ttl: 10) { Rating.recent }
    RatingsJob.perform_in(2.minutes)
    puts "RatingsJob did some work for you, master!"
  end
end
