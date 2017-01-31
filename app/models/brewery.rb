class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { only_integer: true }
  validate :acceptable_years

  def acceptable_years
  	if self.year < 1042
      	errors.add(:year, "can't be that old!")
    end
    if self.year > Date.current.year
      errors.add(:year, "- We are not in the future yet, are we?")
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2017
    puts "changed year to #{year}"
  end

  def to_s
    "#{name}"
  end

end
