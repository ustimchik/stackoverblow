require 'rails_helper'

feature 'User can add links while editing the answer', %q{
  In order to add reference to external resources
  As answer owner
  I'd like to be able to add links to the answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given (:url) { 'https://go.teachbase.ru/sessions/93683/tasks/35814' }

  scenario 'User adds links while editing the answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Text of the answer'
    click_on 'Answer'
    click_on 'Edit'
    within '.answers' do
      click_on 'add link'
    end
    fill_in 'Link name', with: 'My link'
    fill_in 'Link URL', with: url
    click_on 'Save'

    expect(page).to have_link 'My link', href: url
  end
end