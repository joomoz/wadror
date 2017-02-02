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

end
