require 'rails_helper'

feature 'User can add links to the answer', %q{
  In order to provide reference to external resources
  As logged on user creating the answer
  I'd like to be able to add links to the answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given (:url) { 'https://go.teachbase.ru/sessions/93683/tasks/35814' }

  scenario 'User adds link when creating the answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer text'
    click_on 'add link'
    fill_in 'Link name', with: 'My link'
    fill_in 'Link URL', with: url
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: url
    end
  end
end