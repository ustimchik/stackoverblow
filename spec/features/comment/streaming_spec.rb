require 'rails_helper'

feature 'User can see the newly added comment', %q{
  For a better UI experience
  As guest or signed in user
  I'd like to see new comments of other users in real time without refreshing
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'any user is able to see a new comment of another user in real time', js: true do

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
      within '.question' do
        fill_in 'Your comment', with: 'Text of the question comment'
        click_on 'Submit comment'
      end
      sleep 1
      within "#answer-#{answer.id}" do
        fill_in 'Your comment', with: 'Text of the answer comment'
        click_on 'Submit comment'
      end
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Text of the question comment'
      expect(page).to have_content 'Text of the answer comment'
    end

    Capybara.using_session('user') do
      expect(page).to have_content 'Text of the question comment'
      expect(page).to have_content 'Text of the answer comment'
    end
  end
end