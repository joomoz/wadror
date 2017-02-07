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
                       format: { with: /.*[A-Z].*[0-9]|.*[0-9].*[A-Z]/,
                         message: "has to have at least one number and one capital letter"}

   def favorite_beer
     return nil if ratings.empty?
     ratings.order(score: :desc).limit(1).first.beer
   end

   # Searches best average among different styles from user's ratings
   def favorite_style
     return nil if ratings.empty?
     # List all styles that user has rated
     styles = ratings.map{ |rating| rating.beer.style }.uniq
     # Calculate averages for those styles with style_rating method,
     # sort the results and pick largest (last) average
     styles.sort_by{|style| style_rating(style)}.last
   end

   # Searches best average among different breweries from user's ratings
   def favorite_brewery
     return nil if ratings.empty?
     # List all breweries that user has rated
     breweries = ratings.map{ |rating| rating.beer.brewery }.uniq
     # Calculate averages for those breweries with brewery_rating method,
     # sort the results and pick largest (last) average
     breweries.sort_by{|brewery| brewery_rating(brewery)}.last
   end


   #Helper methods
   private

   # Calculate average rating for one style
   def style_rating(style)
     style_ratings = ratings.select{ |r| r.beer.style == style }
     average(style_ratings)
   end

   # Calculate average rating for one brewery
   def brewery_rating(brewery)
     brewery_ratings = ratings.select{ |r| r.beer.brewery == brewery }
     average(brewery_ratings)
   end

   # Average rating method
   def average(ratings)
     ratings.inject(0.0){|sum, r| sum + r.score } / ratings.count
   end

end
