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
        .and change { ActionMailer::Base.deliveries.count }.by(1)

      # Verify created user
      created_user = User.last
      expect(created_user.email). to eq(user.email)
      expect(created_user.username). to eq(user.username)
      expect(created_user.phone_number). to eq(user.phone_number)
      expect(created_user.role).to eq(User::STRING_ROLE_MEMBER)
      expect(created_user.confirmed_at).to be_nil

      # Verify confirmation email sent
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to contain_exactly(user.email)
      confirmation_link = Rails.application.routes.url_helpers
        .user_confirmation_url(confirmation_token: created_user.confirmation_token, host: 'localhost', port: 3000)
      expect(email.body).to have_xpath("//a[@href = '#{confirmation_link}']")

      # Created user cannot sign in yet
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
      expect(page).to have_content('confirm')
    end
  end

end
