require 'beermapping_api'
require 'weather_api'

class PlacesController < ApplicationController
  before_action :set_weather, only: [:search]

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

  private
    def set_weather
      @weather = WeatherApi.weather_in(params[:city])
    end

end
