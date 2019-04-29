require 'rails_helper'

feature 'User can add links to the question', %q{
  In order to provide reference to external resources
  As logged on user creating the question
  I'd like to be able to add links to the question
} do

  given!(:user) { create(:user) }
  given (:url) { 'https://go.teachbase.ru/sessions/93683/tasks/35814' }
  given (:gist_url) { 'https://gist.github.com/ustimchik/62de74c20d955de75e273f2321952348' }

  before do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question text'
    click_on 'add link'
  end

  scenario 'User adds link when creating the question', js: true do
    fill_in 'Link name', with: 'My link'
    fill_in 'Link URL', with: url
    click_on 'Ask'

    expect(page).to have_link 'My link', href: url
  end

  scenario 'User adds GIST link when creating the answer', js: true do
    fill_in 'Link name', with: 'Gist link'
    fill_in 'Link URL', with: gist_url
    click_on 'Ask'
    # I have implemented a module that allows to wait for all ajax to complete. I have also
    # tried sleep, however, in rspec environment it still does not load the external js
    wait_for_ajax

    expect(page).to have_content("Embedded gist: Gist link")
    # expect(page).to have_selector(:css, 'script')
  end
end