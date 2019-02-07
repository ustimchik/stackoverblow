require 'rails_helper'

feature 'User can create answer', %q{
  In order to provide information
  As an authenticated user
  I'd like to be able to answer the questions
} do

  given(:question) { create(:question) }

  background do
    visit question_path(question)
  end

  scenario 'User answers the question' do

    fill_in 'Title', with: 'Test answer'
    fill_in 'Body', with: 'Text of the answer'
    click_on 'Answer'
    expect(page).to have_content 'answer created'
    expect(page).to have_content 'Test answer'
    expect(page).to have_content 'Text of the answer'
  end

  scenario 'User answers the question with errors' do
    click_on 'Answer'
    expect(page).to have_field 'Title'
    expect(page).to have_field 'Body'
    expect(page).to have_content "Title can't be blank"
  end

end