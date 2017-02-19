require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "is saved with a proper name and style" do
      style = FactoryGirl.create :style
      beer = Beer.create name:"Beer", style:style
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
  end

  it "is not saved without a proper name" do
      style = FactoryGirl.create :style
      beer = Beer.create name:"", style:style
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
      beer = Beer.create name:"Bisse"
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
  end

end
