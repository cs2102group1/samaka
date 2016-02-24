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

      user = FactoryGirl.build(:user)

      # Fill in valid register details
      expect {
        fill_in 'Email', with: user.email
        fill_in 'Username', with: user.username
        fill_in :user_password, with: user.password
        fill_in 'Password confirmation', with: user.password
        fill_in 'Phone number', with: user.phone_number

        click_button 'Sign up'
      }.to change { User.count }.by(1)
    end
  end

end
