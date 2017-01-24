class RatingsController < ApplicationController
  def index
    #render :index    # renderöin näkymätemplate /app/views/ratings/index.html
    @ratings = Rating.all
  end
end
