module RatingAverage
  extend ActiveSupport::Concern
  #Calculates average from ratings
  def average_rating
    # alternative and maybe faster way (doesn't work if some ratings are missing)
    # ratings.average(:score)

    sum = ratings.inject(0.0) {|result, n| result + n.score }
    if sum == 0
      return 0
    end

    sum / ratings.count.round(2)
  end
end
