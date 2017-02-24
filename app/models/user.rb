class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30}

  validates :password, length: { minimum: 4},
                       format: { with: /([A-Z].*\d)|(\d.*[A-Z].*)/,
                         message: "has to have at least one number and one capital letter"}

   def self.top(n)
     User.all.sort_by{ |user| -user.ratings.count }.first(n)
   end

   def favorite_beer
     return nil if ratings.empty?
     ratings.order(score: :desc).limit(1).first.beer
   end

   # Searches best average among different styles from user's ratings
   def favorite_style
     favorite :style
   end

   # Searches best average among different breweries from user's ratings
   def favorite_brewery
     favorite :brewery
   end

   def favorite(category)
    return nil if ratings.empty?
    # List all uniq categories that user has rated
    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    # Calculate averages for those vategories with rating_of method,
    # sort the results and pick largest (last) average
    rated.sort_by { |item| -rating_of(category, item) }.first
  end

   # Calculate average rating for certain category
   def rating_of(category, item)
     ratings_of = ratings.select{ |r| r.beer.send(category) == item }
     ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
   end

   # Helper methods
   # private

   # Average rating method
   # def average(ratings)
     # ratings.inject(0.0){|sum, r| sum + r.score } / ratings.count
     # Alternative way
     # ratings.map(&:score).inject(&:+) / ratings.count.to_f
   # end

end
