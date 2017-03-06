class RatingsController < ApplicationController

  # GET /ratings
  # index uses Rails cache to improve performance. There is also a ratings_job task that automatically updates
  # these caches after the home page (breweries) is opened.
  def index
    @ratings = Rating.includes(:beer, :user).all
    @top_beers = Rails.cache.fetch("top_3_beers", expires_in: 2.minutes, race_condition_ttl: 10) { Beer.top(3) }
    @top_breweries = Rails.cache.fetch("top_3_breweries", expires_in: 2.minutes, race_condition_ttl: 10) { Brewery.top(3) }
    @top_styles = Rails.cache.fetch("top_3_styles", expires_in: 2.minutes, race_condition_ttl: 10) { Style.top(3) }
    @top_users = Rails.cache.fetch("top_3_users", expires_in: 2.minutes, race_condition_ttl: 10) { User.top(3) }
    @recent_ratings = Rails.cache.fetch("recent_ratings", expires_in: 2.minutes, race_condition_ttl: 10) { Rating.recent }
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
