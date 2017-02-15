class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.place(session[:cache_city], params[:id])
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:cache_city] = params[:city]
      render :index
    end
  end

end
