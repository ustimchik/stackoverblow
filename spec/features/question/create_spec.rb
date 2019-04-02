require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) {create(:user)}

  context 'Authenticated user asks a question' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'with no errors' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text of the question'
      click_on 'Ask'
      expect(page).to have_content 'question created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Text of the question'
    end

    scenario 'with errors' do
      click_on 'Ask'
      expect(page).to have_field 'Title'
      expect(page).to have_field 'Body'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'with no errors and with attached files', js: true do
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text of the question'
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'Unauthenticated user' do

    scenario 'asks a question' do
      visit questions_path
      click_on 'Ask question'
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
  end
end