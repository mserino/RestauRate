require 'rails_helper'

describe 'restaurants listing page' do
  context 'no restaurants' do
    it 'tells me there a no restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
    end
  end

  context 'are restaurants' do
    before do
      Restaurant.create(name: 'Ledbury', cuisine: 'French')
    end

    it 'should show the restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'Ledbury'
    end
  end
end

describe 'restaurant creation form' do
  context 'logged out' do
    it 'should forward user to sign in page' do
      visit '/restaurants'
      click_link 'Create restaurant'
      expect(page).to have_content 'sign in'
    end
  end

  context 'logged in' do
    before do
      user = User.create email: 'user@email.com', password: '12345678', password_confirmation: '12345678'
      login_as user
    end

    context 'input is valid' do
      it 'should be able to create a restaurant' do
        visit '/restaurants/new'
        fill_in 'Name', with: 'Burger King'
        fill_in 'Cuisine', with: 'Chicken'
        click_button 'Create Restaurant'
        expect(current_path).to eq '/restaurants'
        expect(page).to have_content 'Burger King'
      end

      it 'can add the cuisine to the restaurant' do
        visit '/restaurants/new'
        fill_in 'Name', with: 'Burger King'
        fill_in 'Cuisine', with: 'Fast Food'
        click_button 'Create Restaurant'
        expect(page).to have_content 'Burger King (Fast Food)'
      end
    end

    # NEW TESTS JULY 2
    context 'input is not valid' do
      it 'when creating a restaurant' do
        visit '/restaurants/new'
        fill_in 'Name', with: 'burger king'
        fill_in 'Cuisine', with: 'fff'
        click_button 'Create Restaurant'
        expect(page).to have_content 'Errors'
        expect(page).not_to have_content 'burger king (fff)'
      end
    end
  end

  context 'validity' do
    it 'should have a name' do
      restaurant = Restaurant.new(name: nil)
      expect(restaurant).to have(2).error_on(:name)
      expect(restaurant).not_to be_valid
    end
    it 'should have a name with the first letter capitalized' do
      restaurant = Restaurant.new(name: 'burger king')
      expect(restaurant).to have(1).error_on(:name)
    end
    it 'should have a cuisine' do
      restaurant = Restaurant.new(cuisine: nil)
      expect(restaurant).to have(2).error_on(:cuisine)
      expect(restaurant).not_to be_valid
    end
    it 'should have a cuisine of at least 3 characters' do
      restaurant = Restaurant.new(cuisine: 'ff')
      expect(restaurant).to have(1).error_on(:cuisine)
      expect(restaurant).not_to be_valid
    end
  end
end