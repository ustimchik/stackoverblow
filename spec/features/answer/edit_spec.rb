require 'rails_helper'

feature 'User can edit answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit questions_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea#answer_body'
      end
    end
    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
      within '.answer-errors' do
        expect(page).to have_content "can't be blank"
      end
    end
    scenario "does not have option to edit answer of another user" do
      sign_in other_user
      visit questions_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits his answer with no errors and attaches files', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end


  end
end