require 'rails_helper'

feature 'User can sign up', %q{
  In order to start using the system
  As unauthenticated new user
  I'd like to be able to sign up
} do
    given(:user) { create :user }

    background do
      visit new_user_registration_path
    end

    scenario 'User registers without errors' do
      fill_in 'Email', with: 'user2@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

      open_email('user2@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed'
    end

    scenario 'User attempts to register with error - existing email' do
      fill_in 'Email', with: user.email
      fill_in 'user_password', with: '12345678'
      click_on 'Sign up'
      expect(page).to have_content 'Email has already been taken'
    end

    scenario 'User attempts to register with error - not filling the fields' do
      click_on 'Sign up'
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end
  end