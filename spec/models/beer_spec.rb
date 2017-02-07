require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "is saved with a proper name and style" do
      beer = Beer.create name:"Beer", style:"Lager"
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
  end

  it "is not saved without a proper name" do
      beer = Beer.create name:"", style:"Lager"
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
      beer = Beer.create name:"Bisse", style:""
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
  end

end
