require 'rails_helper'

feature 'User can see the newly added questions', %q{
  For a better UI experience
  As guest or signed in user
  I'd like to see new questions of other users realtime without refreshing
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }

  scenario 'any user is able to see a new question of another user realtime', js: true do
    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      sign_in other_user
      visit questions_path
    end

    Capybara.using_session('owner') do
      sign_in user
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text of the question'
      click_on 'Ask'
    end

    Capybara.using_session('guest') do
      within '.questions' do
        expect(page).to have_content 'Test question'
      end
    end

    Capybara.using_session('user') do
      within '.questions' do
        expect(page).to have_content 'Test question'
      end
    end
  end
end