class RatingsController < ApplicationController

  # GET /ratings
  def index
    #render :index    # renders viewtemplate /app/views/ratings/index.html
    @ratings = Rating.all
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    # Rating.create beer_id: params[:rating][:beer_id], score: params[:rating][:score]
    # is same as;
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      current_user.ratings << @rating
      # Stored in the session where rating was done
      #session[:last_rating] = "#{rating.beer.name} - #{rating.score} points"
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to :back
  end

end
