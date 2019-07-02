require 'rails_helper'

feature 'User can create answer', %q{
  In order to provide information
  As an authenticated user
  I'd like to be able to answer the questions
} do

  given(:user) {create(:user)}
  given(:question) { create(:question) }

  context 'Authenticated user creates answer' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with no errors', js: true do

      fill_in 'New answer', with: 'Text of the answer'
      click_on 'Answer'
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Text of the answer'
      end
    end
    scenario 'with errors', js: true do
      click_on 'Answer'
      expect(page).to have_field 'New answer'
      expect(page).to_not have_content 'Text of the answer'
      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'with no errors and with attached files', js: true do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      fill_in 'New answer', with: 'Text of the answer'
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'Unauthenticated user', js: true do
    scenario 'asks a question' do
      visit question_path(question)
      fill_in 'New answer', with: 'Text of the answer'
      click_on 'Answer'

      expect(page).to_not have_content 'Text of the answer'
    end
  end

end