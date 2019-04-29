require 'rails_helper'

feature 'User can add links while editing the question', %q{
  In order to add reference to external resources
  As question owner
  I'd like to be able to add links to the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given (:url) { 'https://go.teachbase.ru/sessions/93683/tasks/35814' }

  scenario 'User adds links while editing the question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Edit'
    within '.question' do
      click_on 'add link'
    end
    fill_in 'Link name', with: 'My link'
    fill_in 'Link URL', with: url
    click_on 'Save'

    expect(page).to have_link 'My link', href: url
  end
end