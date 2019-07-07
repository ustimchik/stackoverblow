require 'rails_helper'
require 'capybara/email/rspec'

feature 'User can sign up and sign in with social networks', %q{
  In order to start using the system with less efforts
  As any user
  I'd like to be able to sign up and sign in with social networks
} do

  describe 'Sign in/up using github (email provided)' do

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Could not authenticate you from GitHub')
    end

    context 'authorization exists' do
      given!(:user) {create(:user)}

      before do
        user.authorizations.create(provider: 'github', uid: '123545')
        mock_auth_hash(:github, user.email)
        visit new_user_session_path
        click_on 'Sign in with GitHub'
      end

       scenario 'signs in' do
        expect(page).to have_content('Successfully authenticated from github account.')
      end
    end

    context 'authorization does NOT exist' do
      before do
        mock_auth_hash(:github, 'user@test.com')
        visit new_user_session_path
        click_on 'Sign in with GitHub'
      end

      scenario 'signs in' do
        expect(page).to have_content('Successfully authenticated from github account.')
      end
    end
  end

  describe 'Sign in/up using twitter (no email provided)' do

    scenario 'can handle authentication error' do
      mock_auth_hash(:twitter, nil)
      visit new_user_session_path
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Could not authenticate you from Twitter')
    end

    context 'authorization exists' do
      given!(:user) {create(:user)}

      before do
        user.authorizations.create(provider: 'twitter', uid: '123545')
        mock_auth_hash(:twitter, nil)
        visit new_user_session_path
        click_on 'Sign in with Twitter'
      end

      scenario 'signs in' do
        expect(page).to have_content('Successfully authenticated from twitter account.')
      end
    end

    context 'authorization does not exist' do
      before do
        mock_auth_hash(:twitter, nil)
        visit new_user_session_path
        click_on 'Sign in with Twitter'
      end

      scenario 'logs user in after email confirmation' do
        expect(page).to have_content('Please enter e-mail to complete registration')
        fill_in 'email', with: 'user@test.com'
        click_on 'Confirm email'
        sleep 1

        open_email('user@test.com')
        current_email.click_link 'Confirm my account'
        expect(page).to have_content('Your email address has been successfully confirmed')
      end
    end
  end

end