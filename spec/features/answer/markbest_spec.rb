require 'rails_helper'

feature 'User can mark answer best', %q{
  In order to let everyone know most helpful answer
  As an author of question
  I'd like to be able to mark one of the answers best
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }
  given!(:other_answer) { create(:answer, question: question, user: other_user) }

  scenario 'Unauthenticated user can not mark answer best' do
    visit questions_path(question)

    expect(page).to_not have_button 'Mark Best'
  end

  scenario 'Authenticated, but not an author of the question can not mark answer best' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_button 'Mark Best'
  end

  describe 'Authenticated question author', js: true do
    before do
      sign_in user
      visit question_path(question)
      within "#answer-#{answer.id}" do
        click_on 'Mark Best'
      end
      wait_for_ajax
    end

    scenario 'marks answer best first time', js: true do
      expect(page).to have_content 'Answer was successfully marked the best.'
      within '.answer-best' do
        expect(page).to have_content answer.body
      end
    end
    scenario 'marks another answer best', js: true do
      within "#answer-#{other_answer.id}" do
        click_on 'Mark Best'
      end
      wait_for_ajax

      expect(page).to have_content 'Answer was successfully marked the best.'
      within '.answer-best' do
        expect(page).to have_content other_answer.body
      end
    end
  end

end