class RatingsController < ApplicationController

  # GET /ratings
  def index
    @ratings = Rating.includes(:beer, :user).all
    @recent_ratings = Rating.recent
    @top_breweries = Brewery.top(3)
    @top_beers = Beer.top(3)
    @top_styles = Style.top(3)
    @top_users = User.top(3)
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

    if current_user.nil?
      redirect_to signin_path, notice:'You have to be signed in!'
    elsif @rating.save
      current_user.ratings << @rating
      # Stored in the session where rating was done
      #session[:last_rating] = "#{rating.beer.name} - #{rating.score} points"
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end
