require 'rails_helper'

feature 'User can delete question', %q{
  In order to remove question provided by mistake
  As an authenticated user
  I'd like to be able to delete my question
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his question' do
    question_body = question.body
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_no_content(question_body)
    expect(page).to have_content 'question deleted'
  end

  scenario "Other authenticated user is not able to see delete option for someone's question" do
    sign_in(wrong_user)
    visit question_path(question)
    expect(page).to have_no_link('Delete')
  end

  scenario 'Non-authenticated user is not able to see delete option' do
    visit question_path(question)
    expect(page).to have_no_link('Delete')
  end
end