require 'rails_helper'

include Helpers

describe "Beer (page)" do
  before :each do
    FactoryGirl.create :brewery, name:"Koff"
  end

  it "can be added with a proper name" do
    visit new_beer_path
    fill_in('beer_name', with:'Duff')
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not saved without a name" do
    visit new_beer_path
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')
    click_button "Create Beer"
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to be(0)
  end

end
