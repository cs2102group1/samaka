require 'rails_helper'

feature 'Authentication', type: :feature do

  context 'User has not signed in and' do
    scenario 'visits home page' do
      visit root_path
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Register')
    end

    scenario 'registers an account' do
      visit root_path
      find_link('Register').click
      expect(current_path).to eq(new_user_registration_path)

      # Fill in valid register details
      user_details = FactoryGirl.attributes_for(:user)
      fill_in 'Email', with: user_details[:email]
      fill_in :user_password, with: user_details[:password]
      fill_in 'Password confirmation', with: user_details[:password]
      click_button 'Sign up'
    end
  end

end
