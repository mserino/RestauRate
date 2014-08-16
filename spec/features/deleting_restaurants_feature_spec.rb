require 'rails_helper'

context 'logged out' do
	before do
		Restaurant.create(name: 'Ledbury', cuisine: 'French')
	end
	it 'cannot delete restaurants' do
		visit '/restaurants'
		expect(page).not_to have_link 'Delete Ledbury'
	end
end

context 'logged in as the restaurant creator' do
	before do
		alex = User.create(email: 'alex@alex.com', password: '12345678', password_confirmation: '12345678')
		login_as alex

		alex.restaurants.create(name: 'Ledbury', cuisine: 'French')
	end
  it 'can delete a restaurant' do
    visit '/restaurants'
    expect(page).to have_content 'Delete Ledbury'
    click_link 'Delete Ledbury'
    expect(page).to have_content 'Successfully deleted Ledbury'
  end
end

context 'logged in NOT as the restaurant creator' do
	before do
		alex = User.create(email: 'alex@alex.com', password: '12345678', password_confirmation: '12345678')
		will = User.create(email: 'will@alex.com', password: '12345678', password_confirmation: '12345678')
		login_as will

		alex.restaurants.create(name: 'Ledbury', cuisine: 'French')
	end
  it 'cannot delete a restaurant' do
    visit '/restaurants'
    click_link 'Delete Ledbury'
    expect(page).to have_content 'Not your restaurant!'
  end
end