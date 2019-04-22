require 'rails_helper'

feature 'User can remove any attachment', %q{
  In order to delete unnecessary file
  As an author of question
  I'd like to be able to remove any attachment
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, :with_attachment, user: user) }

  scenario 'Unauthenticated user does not have remove attachment button' do
    visit questions_path(question)

    expect(page).to_not have_button 'Remove file'
  end

  scenario 'Authenticated, but not an answer author does not have remove attachment button' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_button 'Remove file'
  end

  describe 'Authenticated answer author', js: true do
    before do
      sign_in(user)
      visit question_path(question)
      click_on 'Remove file'
    end

    scenario 'deletes attachment from the answer', js: true do
      expect(page).to have_content 'Attachment has been removed.'
      expect(page).to_not have_link "spec_helper.rb"
    end

  end
end