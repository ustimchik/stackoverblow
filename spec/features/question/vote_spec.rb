require 'rails_helper'

feature 'User can vote for the question', %q{
  In order to raise/drop question in ratings
  As authenticated user but NOT a question owner
  I'd like to be able to vote up/down for the question
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'non-authenticated user' do
    scenario 'does not have vote buttons for the question' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Upvote')
      expect(page).to_not have_selector(:link_or_button, 'Clear vote')
      expect(page).to_not have_selector(:link_or_button, 'Downvote')
    end
  end

  context 'authenticated user' do
    context 'question owner' do
      scenario 'does not have vote buttons for the question' do
        sign_in(user)
        visit question_path(question)

        expect(page).to_not have_selector(:link_or_button, 'Upvote')
        expect(page).to_not have_selector(:link_or_button, 'Clear vote')
        expect(page).to_not have_selector(:link_or_button, 'Downvote')
      end
    end
    context 'NOT a question owner' do
      context 'for the first time' do
        before js: true do
          sign_in(other_user)
          visit question_path(question)
        end
        scenario 'upvotes the question', js: true do
          within '.qvotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content 1
          end
        end
        scenario 'downvotes the question', js: true do
          within '.qvotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content -1
          end
        end
      end
      context 'when already upvoted' do
        before js: true do
          sign_in(other_user)
          visit question_path(question)
          within '.qvotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax
        end
        scenario 'upvotes the question', js: true do
          within '.qvotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content 1
          end
        end
        scenario 'downvotes the question', js: true do
          within '.qvotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content -1
          end
        end
        scenario 'clears vote for the question', js: true do
          within '.qvotebuttons' do
            find('.clearvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content 0
          end
        end
      end
      context 'when already downvoted' do
        before js: true do
          sign_in(other_user)
          visit question_path(question)
          within '.qvotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax
        end
        scenario 'upvotes the question', js: true do
          within '.qvotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content 1
          end
        end
        scenario 'downvotes the question', js: true do
          within '.qvotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content -1
          end
        end
        scenario 'clears vote for the question', js: true do
          within '.qvotebuttons' do
            find('.clearvote').click
          end
          wait_for_ajax

          within '.votescore' do
            expect(page).to have_content 0
          end
        end
      end
    end
  end

end