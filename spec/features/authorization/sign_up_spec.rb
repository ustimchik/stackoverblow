require 'rails_helper'

feature 'User can sign up', %q{
  In order to start using the system
  As unauthenticated new user
  I'd like to be able to sign up
} do
    given(:user) { User.create(email: 'user@test.com', password: '12345678') }

    background do
      visit new_user_registration_path
    end

    scenario 'User attempts to register without errors' do
      fill_in 'Email', with: 'user2@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'
      expect(page).to have_content 'signed up successfully'
    end

    scenario 'User attempts to register with error - existing email' do
      fill_in 'Email', with: user.email
      fill_in 'user_password', with: user.password
      click_on 'Sign up'
      expect(page).to have_content 'Email has already been taken'
    end

    scenario 'User attempts to register with error - not filling the fields' do
      click_on 'Sign up'
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end
  end