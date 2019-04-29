require 'rails_helper'

feature 'User can add links to the answer', %q{
  In order to provide reference to external resources
  As logged on user creating the answer
  I'd like to be able to add links to the answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given (:url) { 'https://go.teachbase.ru/sessions/93683/tasks/35814' }
  given (:gist_url) { 'https://gist.github.com/ustimchik/62de74c20d955de75e273f2321952348' }

  before do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer text'
    click_on 'add link'
  end

  scenario 'User adds link when creating the answer', js: true do
    fill_in 'Link name', with: 'My link'
    fill_in 'Link URL', with: url
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: url
    end
  end

  scenario 'User adds gist link when creating the answer', js: true do
    fill_in 'Link name', with: 'Gist link'
    fill_in 'Link URL', with: gist_url
    click_on 'Answer'
    # I have implemented a module that allows to wait for all ajax to complete. I have also
    # tried sleep, however, in rspec environment it still does not load the external js
    wait_for_ajax

    within '.answers' do
      expect(page).to have_content("Embedded gist: Gist link")
      # expect(page).to have_selector(:css, 'script')
    end
  end
end