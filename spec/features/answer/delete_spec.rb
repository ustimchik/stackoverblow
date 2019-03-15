require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove info provided by mistake
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user deletes his answer', js: true do
    answer_content = question.answers.first.body
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_no_content(answer_content)
    expect(page).to have_content 'Answer was successfully deleted.'
  end

  scenario "Other authenticated user is not able to see delete option for someone's answer" do
    sign_in(wrong_user)
    visit question_path(question)
    expect(page).to have_no_link('Delete')
  end

  scenario 'Non-authenticated user is not able to see delete option' do
    visit question_path(question)
    expect(page).to have_no_link('Delete')
  end
end