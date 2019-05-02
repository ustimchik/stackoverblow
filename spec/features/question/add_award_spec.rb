require 'rails_helper'

feature 'User can add award to the question', %q{
  In order to encourage other users to answer
  As logged on user creating the question
  I'd like to be able to add award to the question
} do

  given!(:user) { create(:user) }

  scenario 'User adds award when creating the question', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question text'
    fill_in 'Award name', with: 'My award'
    attach_file 'Award image', "#{Rails.root}/app/assets/images/test_image.png"
    click_on 'Ask'

    expect(page).to have_content 'My award'
    expect(page).to have_css("img[src*='test_image.png']")
  end
end