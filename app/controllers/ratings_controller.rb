class RatingsController < ApplicationController

  # GET /ratings
  def index
    #render :index    # renders viewtemplate /app/views/ratings/index.html
    @ratings = Rating.all
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  def create
    # Rating.create beer_id: params[:rating][:beer_id], score: params[:rating][:score]
    # is same as;
    Rating.create params.require(:rating).permit(:score, :beer_id)
    redirect_to ratings_path
  end

end
