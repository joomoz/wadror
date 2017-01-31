module RatingAverage
  extend ActiveSupport::Concern
  #Calculates average from ratings
  def average_rating
    #ratings.inject(0.0) {|result, n| result + n.score } / ratings.count
    # alternative and maybe faster way
    ratings.average(:score)
  end
end