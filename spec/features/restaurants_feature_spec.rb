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

describe 'validity' do
  it 'should have a name' do
    restaurant = Restaurant.new(name: nil)
    expect(restaurant).to have(2).error_on(:name)
    expect(restaurant).not_to be_valid
  end
# pending
  it 'should allow a name starting with a number'
# end pending
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

describe 'restaurant edit form' do
  before{Restaurant.create name: 'KFC', cuisine: 'Chicken'}

  it 'should be able to edit a restaurant' do
    visit '/restaurants'
    click_link 'Edit KFC'
    fill_in 'Name', with: 'Kentucky Fried Chicken'
    click_button 'Update Restaurant'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'Kentucky Fried Chicken'
  end
end

describe 'deleting restaurants' do
    before{Restaurant.create name: 'KFC', cuisine: 'Chicken'}

    it 'can delete a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'Delete KFC'
      click_link 'Delete KFC'
      expect(page).to have_content 'Successfully deleted KFC'
    end    
end