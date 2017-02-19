require 'rails_helper'

RSpec.describe User, type: :model do

  it "has the username set correctly" do
    user = FactoryGirl.create(:user)
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password"do
    user = User.create username:"John", password:"Pw1", password_confirmation:"Pw1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password that has only letters"do
    user = User.create username:"John", password:"Password", password_confirmation:"Password"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
      let(:user){FactoryGirl.create(:user) }
      let(:style){FactoryGirl.create(:style) }
      style2 = FactoryGirl.create :style2

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_beer)
      end

      it "without ratings does not have one" do
        expect(user.favorite_beer).to eq(nil)
      end

      it "is the only rated if only one beer rated" do
        beer = create_beer_with_rating(user, style, 10)
        expect(user.favorite_beer).to eq(beer)
      end

      it "is the beer with highest rating if several rated" do
        create_beers_with_ratings(user, style, 10, 20, 15, 7, 9)
        best = create_beer_with_rating(user, style2, 25)
        expect(user.favorite_beer).to eq(best)
      end
  end

  describe "favorite style" do
      let(:user){FactoryGirl.create(:user) }
      let(:style){FactoryGirl.create(:style) }
      style2 = FactoryGirl.create :style2
      style3 = FactoryGirl.create :style3

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_style)
      end

      it "without ratings does not have one" do
        expect(user.favorite_style).to eq(nil)
      end

      it "is the only rated if only one style rated" do
        beer = create_beer_with_rating(user, style, 10)
        expect(user.favorite_style).to eq(beer.style)
      end

      it "is the style with highest rating if several rated" do
        create_beers_with_ratings(user, style, 10, 11, 12, 13, 14, 15)
        create_beers_with_ratings(user, style2, 20, 25, 30)
        create_beers_with_ratings(user, style3, 40, 45, 50)
        expect(user.favorite_style).to eq(style3)
      end

  end

  describe "favorite brewery" do
      let(:user){FactoryGirl.create(:user) }

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_brewery)
      end

      it "without ratings does not have one" do
        expect(user.favorite_brewery).to eq(nil)
      end

      it "is the only rated if only one brewety rated" do
        brewery = create_brewery_with_rated_beer(user, 15)
        expect(user.favorite_brewery).to eq(brewery)
      end

      it "is the brewery with highest rating if several rated" do
        brewery1 = create_brewery_with_rated_beer(user, 15)
        brewery2 = create_brewery_with_rated_beer(user, 20)
        brewery_best = create_brewery_with_rated_beer(user, 45)
        expect(user.favorite_brewery).to eq(brewery_best)
      end
  end

end

def create_brewery_with_rated_beer(user, score)
  brewery = FactoryGirl.create(:brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  brewery
end

def create_beer_with_rating(user, style, score)
  beer = FactoryGirl.create(:beer, style: style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(user, style, *scores)
  scores.each do |score|
    create_beer_with_rating(user, style, score)
  end
end
