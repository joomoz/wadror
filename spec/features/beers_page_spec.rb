require 'rails_helper'

include Helpers

describe "Beer page" do
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:style) { FactoryGirl.create :style }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "can be added with a proper name" do
    visit new_beer_path
    fill_in('beer_name', with:'Duff')
    #select('Lager', from:'beer[style_id]')
    #select('Koff', from:'beer[brewery_id]')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not saved without a name" do
    visit new_beer_path
    #select('Lager', from:'beer[style_id]')
    #select('Koff', from:'beer[brewery_id]')
    click_button "Create Beer"
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to be(0)
  end

end
