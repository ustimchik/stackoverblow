require 'rails_helper'

feature 'User can edit comment', %q{
  In order to correct mistakes
  As an author of comment
  I'd like to be able to edit my comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }
  given!(:comment_question) { create(:comment, user: user, commentable: question, body: "Test question comment") }
  given!(:comment_answer) { create(:comment, user: user, commentable: answer, body: "Test answer comment") }


  scenario 'Unauthenticated user does not see edit link' do
    visit question_path(question)

    within "#comment-#{comment_question.id}" do
      expect(page).to_not have_link 'Edit'
    end

    within "#comment-#{comment_answer.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his comment to question', js: true do
      sign_in user
      visit question_path(question)

      within "#comment-#{comment_question.id}" do
        click_on 'Edit'
        fill_in 'Your comment', with: 'edited question comment'
        click_on 'Update comment'

        expect(page).to_not have_content comment_question.body
        expect(page).to have_content 'edited question comment'
        expect(page).to_not have_selector 'textarea#comment_body'
      end
    end

    scenario 'edits his comment to answer', js: true do
      sign_in user
      visit question_path(question)

      within "#comment-#{comment_answer.id}" do
        click_on 'Edit'
        fill_in 'Your comment', with: 'edited answer comment'
        click_on 'Update comment'

        expect(page).to_not have_content comment_answer.body
        expect(page).to have_content 'edited answer comment'
        expect(page).to_not have_selector 'textarea#comment_body'
      end
    end

    scenario 'does not have option to edit comments of another user' do
      sign_in other_user
      visit question_path(question)

      within "#comment-#{comment_question.id}" do
        expect(page).to_not have_link 'Edit'
      end

      within "#comment-#{comment_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end