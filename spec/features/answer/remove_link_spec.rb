require 'rails_helper'

feature 'User can remove links from the answer', %q{
  In order to remove reference to external resources
  As answer owner
  I'd like to be able to remove links from the answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given (:url) { 'https://go.teachbase.ru/sessions/93683/tasks/35814' }

  scenario 'User removes links when editing the question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'New answer', with: 'Text of the answer'
    click_on 'Answer'
    click_on 'Edit'
    within '.answers' do
      click_on 'add link'
    end
    fill_in 'Link name', with: 'My link'
    fill_in 'Link URL', with: url
    click_on 'Save'
    visit question_path(question)
    click_on 'Edit'
    click_on 'remove link'
    click_on 'Save'

    expect(page).to_not have_link 'My link', href: url
  end
end