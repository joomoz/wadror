require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(
      nil
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several places are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("test").and_return(
      [ Place.new( name:"BeerBar1", id: 1 ),
        Place.new( name:"BeerBar2", id: 2 ),
        Place.new( name:"BeerBar3", id: 3 )]
    )

    allow(WeatherApi).to receive(:weather_in).with("test").and_return(
      nil
    )

    visit places_path
    fill_in('city', with: 'test')
    click_button "Search"

    expect(page).to have_content "BeerBar1"
    expect(page).to have_content "BeerBar2"
    expect(page).to have_content "BeerBar3"
  end

  it "if there are no places, non are shown" do
    allow(BeermappingApi).to receive(:places_in).with("beerles city").and_return(
      []
    )

    allow(WeatherApi).to receive(:weather_in).with("beerles city").and_return(
      nil
    )

    visit places_path
    fill_in('city', with: 'beerles city')
    click_button "Search"

    expect(page).to have_content "No locations in beerles city"
  end


  def weather_answer
    answer = <<-END_OF_STRING
    {"location"=>
  {"name"=>"Espoo",
   "region"=>"Southern Finland",
   "country"=>"Finland",
   "lat"=>60.22,
   "lon"=>24.67,
   "tz_id"=>"Europe/Helsinki",
   "localtime_epoch"=>1487524609,
   "localtime"=>"2017-02-19 17:16"},
 "current"=>
  {"last_updated_epoch"=>1487524610,
   "last_updated"=>"2017-02-19 17:16",
   "temp_c"=>4.0,
   "temp_f"=>39.2,
   "is_day"=>1,
   "condition"=>{"text"=>"Partly cloudy", "icon"=>"//cdn.apixu.com/weather/64x64/day/116.png", "code"=>1003},
   "wind_mph"=>9.4,
   "wind_kph"=>15.1,
   "wind_degree"=>230,
   "wind_dir"=>"SW",
   "pressure_mb"=>993.0,
   "pressure_in"=>29.8,
   "precip_mm"=>0.4,
   "precip_in"=>0.02,
   "humidity"=>87,
   "cloud"=>0,
   "feelslike_c"=>0.5,
   "feelslike_f"=>32.9,
   "vis_km"=>10.0,
   "vis_miles"=>6.0}}
   END_OF_STRING
  end

end
