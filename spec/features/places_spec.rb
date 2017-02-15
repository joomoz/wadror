require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
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

    visit places_path
    fill_in('city', with: 'beerles city')
    click_button "Search"

    expect(page).to have_content "No locations in beerles city"
  end


end
