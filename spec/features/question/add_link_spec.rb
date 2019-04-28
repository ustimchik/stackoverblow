require 'rails_helper'

feature 'User can add links to the question', %q{
  In order to provide reference to external resources
  As logged on user creating the question
  I'd like to be able to add links to the question
} do

  given!(:user) { create(:user) }
  given (:url) { 'https://go.teachbase.ru/sessions/93683/tasks/35814' }

  scenario 'User adds link when creating the question', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question text'
    click_on 'add link'
    fill_in 'Link name', with: 'My link'
    fill_in 'Link URL', with: url
    click_on 'Ask'

    expect(page).to have_link 'My link', href: url
  end
end