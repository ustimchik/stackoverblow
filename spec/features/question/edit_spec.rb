require 'rails_helper'

feature 'User can edit question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'

      within '.question' do
        fill_in 'Body', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'

      end
    end
    scenario 'edits his question with errors', js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
      end
      within '.question-errors' do
        expect(page).to have_content "can't be blank"
      end
    end
    scenario "does not have option to edit question of another user" do
      sign_in other_user
      visit questions_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end