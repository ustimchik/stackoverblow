require 'rails_helper'

feature 'User can subscribe for question', %q{
  In order to get the daily digest
  As a logged on user
  I'd like to be able to subscribe to a question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user does not see subscribe/unsubscribe button' do
    visit questions_path(question)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    context 'subscribes to a question', js: true do

      scenario 'button changes to unsubscribe' do
        click_on 'Subscribe'
        expect(page).to have_content 'Unsubscribe'
      end
    end

    context 'unsubscribes from a question', js: true do
      given!(:subscription) { create(:subscription, user: user, question: question) }

      scenario 'button changes to Subscribe' do
        visit question_path(question)
        within '.question' do
          click_on 'Unsubscribe'

          expect(page).to have_content 'Subscribe'
        end
      end
    end
  end
end