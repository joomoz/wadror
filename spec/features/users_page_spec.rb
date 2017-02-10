require 'rails_helper'

include Helpers

describe "User (page)" do
  let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back'
      expect(page).to have_content 'Pekka'
    end


    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end


  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has done some ratings" do
    before :each do
      sign_in(username:"Pekka", password:"Foobar1")
      brewery = FactoryGirl.create :brewery, name:"Great Brewery"
      beer1 = FactoryGirl.create :beer, name:"Duff", brewery:brewery
      beer2 = FactoryGirl.create :beer, name:"Budweiser", brewery:brewery
      FactoryGirl.create(:rating, score:23, beer:beer1, user:user)
      FactoryGirl.create(:rating, score:12, beer:beer2, user:user)
      user2 = FactoryGirl.create :user, username:"John"
      sign_in(username:"John", password:"Foobar1")
      FactoryGirl.create(:rating, score:44, beer:beer1, user:user2)
    end

    it "has only own ratings on it's page" do
      visit user_path(user)
      expect(page).to have_content "Duff 23"
      expect(page).to have_content "Budweiser 12"
      expect(page).not_to have_content "Duff 44"
    end

    it "can also remove ratings (also form the db)" do
      sign_in(username:"Pekka", password:"Foobar1")
      visit user_path(user)
      expect{
        page.find('li',:text => 'Duff').click_link('delete')
      }.to change{user.ratings.count}.from(2).to(1)
      #expect(user.ratings.count).to eq(1)
      expect(page).not_to have_content "Duff 23"
    end

    it "has favourite brewery and style visible on the page" do
      visit user_path(user)
      expect(page).to have_content "brewery: Great Brewery"
      expect(page).to have_content "style: Lager"
    end

  end
end
