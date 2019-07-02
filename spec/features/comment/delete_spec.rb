require 'rails_helper'

feature 'User can delete comment', %q{
  In order to remove info provided by mistake
  As an authenticated user
  I'd like to be able to delete my comment
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }

  context 'Within question' do
    given!(:comment) { create(:comment, user: user, commentable: question, body: "Test comment") }

    scenario 'authenticated user deletes his comment', js: true do
      comment_content = comment.body
      sign_in(user)
      visit question_path(question)

      within "#comment-#{comment.id}" do
        click_on 'Delete'
      end

      expect(page).to have_no_content(comment_content)
      expect(page).to have_content 'Comment was successfully deleted.'
    end

    scenario "other authenticated user is not able to see delete option for someone's comment" do
      sign_in(wrong_user)
      visit question_path(question)

      within "#comment-#{comment.id}" do
        expect(page).to have_no_link('Delete')
      end
    end

    scenario 'non-authenticated user is not able to see delete option' do
      visit question_path(question)

      within "#comment-#{comment.id}" do
        expect(page).to have_no_link('Delete')
      end
    end
  end

  context 'Within answer' do
    given!(:comment) { create(:comment, user: user, commentable: answer, body: "Test comment") }

    scenario 'authenticated user deletes his comment', js: true do
      comment_content = comment.body
      sign_in(user)
      visit question_path(question)

      within "#comment-#{comment.id}" do
        click_on 'Delete'
      end

      expect(page).to have_no_content(comment_content)
      expect(page).to have_content 'Comment was successfully deleted.'
    end

    scenario "other authenticated user is not able to see delete option for someone's comment" do
      sign_in(wrong_user)
      visit question_path(question)

      within "#comment-#{comment.id}" do
        expect(page).to have_no_link('Delete')
      end
    end

    scenario 'non-authenticated user is not able to see delete option' do
      visit question_path(question)

      within "#comment-#{comment.id}" do
        expect(page).to have_no_link('Delete')
      end
    end
  end
end