require 'rails_helper'

feature 'User can get and view awards assigned to the question', %q{
  In order to collect the awards
  As logged on user who created the answer that was marked as best
  I'd like to be able to get and see the award
} do


  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, :with_award, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }

  before do
    sign_in user
    visit question_path(question)
  end

  context 'When the answer marked best for the first time', js: true do
    before do
      within "#answer-#{answer.id}" do
        click_on 'Mark Best'
      end
      wait_for_ajax
    end

    scenario 'Authenticated answer owner gets the award', js: true do
      visit user_path(user)

      within '.awards' do
        expect(page).to have_content 'My award'
        expect(page).to have_css("img[src*='test_image.png']")
      end
    end
  end

  context 'After question owner marks another answer best', js: true do
    before do
      within "#answer-#{answer.id}" do
        click_on 'Mark Best'
      end
      wait_for_ajax
    end

    scenario 'previous best answer owner is not able to see the award', js: true do
      within "#answer-#{other_answer.id}" do
        click_on 'Mark Best'
      end
      wait_for_ajax
      visit user_path(user)

      within '.awards' do
        expect(page).to_not have_content 'My award'
        expect(page).to_not have_css("img[src*='test_image.png']")
      end
    end

    scenario 'a new best answer owner is able to see the award', js: true do
      within "#answer-#{other_answer.id}" do
        click_on 'Mark Best'
      end
      wait_for_ajax
      visit user_path(other_user)

      within '.awards' do
        expect(page).to have_content 'My award'
        expect(page).to have_css("img[src*='test_image.png']")
      end
    end
  end
end
