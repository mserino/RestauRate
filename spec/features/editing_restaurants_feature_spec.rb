require 'rails_helper'

context 'logged out' do
	before do
		Restaurant.create name: 'KFC', cuisine: 'Chicken'
	end

	it 'cannot edit restaurant' do
		visit '/restaurants'
		expect(page).not_to have_link 'Edit KFC'
	end
	
end

context 'logged in as the creator of restaurant' do
	before do
		meg = User.create email: 'meg@example.com', password: '12345678', password_confirmation: '12345678'
		login_as meg
		meg.restaurants.create name: 'KFC', cuisine: 'Chicken'
	end
  
  it 'should be able to edit a restaurant' do
    visit '/restaurants'
    click_link 'Edit KFC'
    fill_in 'Name', with: 'Kentucky Fried Chicken'
    click_button 'Update Restaurant'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'Kentucky Fried Chicken'
  end
end

context 'logged in NOT as the creator of restaurant' do
	before do
		meg = User.create email: 'meg@example.com', password: '12345678', password_confirmation: '12345678'
		twist = User.create email: 'twist@example.com', password: '12345678', password_confirmation: '12345678'
		login_as twist
		meg.restaurants.create name: 'KFC', cuisine: 'Chicken'
	end

	it 'should not be able to edit restaurant' do
		visit '/restaurants'
		click_link 'Edit KFC'
		expect(page).to have_content 'Not your restaurant!'
	end

end