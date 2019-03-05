require 'rails_helper'

feature 'User can create answer', %q{
  In order to provide information
  As an authenticated user
  I'd like to be able to answer the questions
} do

  given(:user) {create(:user)}
  given(:question) { create(:question) }

  context 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User creates answer OK', js: true do

      fill_in 'Body', with: 'Text of the answer'
      click_on 'Answer'
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'answer created'
      within '.answers' do
        expect(page).to have_content 'Text of the answer'
      end
    end

    scenario 'User creates answer with errors', js: true do
      click_on 'Answer'
      expect(page).to have_field 'Body'
      expect(page).to_not have_content "Text of the answer"
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'Unauthenticated user' do
    scenario 'asks a question' do
      visit question_path(question)
      click_on 'Answer'
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end

end