class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  validates :username, uniqueness: true,
                      length: { minimum: 3, maximum: 30}

end
