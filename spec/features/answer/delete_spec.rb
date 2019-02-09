require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove info provided by mistake
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:user) {create(:user)}
  given!(:question) { create(:question_with_answers, answers_count: 2) }
  given(:myanswer) { question.answers.first }
  given(:someanswer) { question.answers.second }

  background do
    sign_in(user)
    myanswer.user = user
    myanswer.save!
  end

  scenario 'Authenticated user deletes his answer' do
    visit answer_path(myanswer)
    click_on 'Delete'
    expect(page).to have_no_content(myanswer.title)
    expect(page).to have_no_content(myanswer.body)
    expect(page).to have_content 'answer deleted'
  end

  scenario 'Other users not able to see delete option' do
    visit answer_path(someanswer)
    expect(page).to have_no_content('Delete')
  end
end