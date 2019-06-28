require 'rails_helper'

feature 'User can see the newly added answer', %q{
  For a better UI experience
  As guest or signed in user
  I'd like to see new answers of other users in real time without refreshing
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: other_user) }

  scenario 'any user is able to see a new answer of another user in realtime', js: true do

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      sign_in other_user
      visit question_path(question)
    end

    Capybara.using_session('owner') do
      sign_in user
      visit question_path(question)
      fill_in 'Body', with: 'Text of the answer'
      click_on 'Answer'
    end

    Capybara.using_session('guest') do
      within '.answers' do
        expect(page).to have_content 'Text of the answer'
      end
    end

    Capybara.using_session('user') do
      within '.answers' do
        expect(page).to have_content 'Text of the answer'
      end
    end
  end
end