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

    scenario 'User answers the question' do

      fill_in 'Body', with: 'Text of the answer'
      click_on 'Answer'
      expect(page).to have_content 'answer created'
      expect(page).to have_content 'Text of the answer'
    end

    scenario 'User answers the question with errors' do
      click_on 'Answer'
      expect(page).to have_field 'Body'
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