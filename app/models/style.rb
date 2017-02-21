class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(n)
    Style.all.sort_by{ |s| -(s.average_rating || 0) }.first(n)
  end

  def to_s
    "#{name}"
  end

  def formatted_content
    if description.split.size > 10
      description.split.take(10).join(" ") + "..."
    else
      description
    end
  end

end
