class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  scope :recent, -> { order(created_at: :desc).limit(5) }                                 

  def to_s
    "#{beer.name} #{score}"
  end

  def best_breweries
    return nil if ratings.empty?

    ratings_of_breweries = ratings.group_by { |r| r.beer.brewery }
    averages_of_breweries = []
    ratings_of_breweries.each do |brewery, ratings|
      averages_of_breweries << {
        brewery: brewery,
        rating: ratings.map(&:score).sum / ratings.count.to_f
      }
    end
    averages_of_breweries.sort_by{ |b| -b[:rating] }.first[:brewery]
  end

  #Helper methods
  private

  # Calculate average rating for one brewery
  def average_rating(var)
    rtngs = ratings.select{ |r| r.beer.var == var }
    rtngs.inject(0.0){|sum, r| sum + r.score } / rtngs.count
  end

end
