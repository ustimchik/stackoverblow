require 'rails_helper'

feature 'User can vote for the answer', %q{
  In order to raise/drop answer in ratings
  As authenticated user but NOT an answer owner
  I'd like to be able to vote up/down the answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }


  context 'non-authenticated user' do
    scenario 'does not have vote buttons for the answer' do
      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Upvote')
      expect(page).to_not have_selector(:link_or_button, 'Clear vote')
      expect(page).to_not have_selector(:link_or_button, 'Downvote')
    end
  end

  context 'authenticated user' do
    context 'answer owner' do
      scenario 'does not have vote buttons for the question' do
        sign_in(other_user)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_selector(:link_or_button, 'Upvote')
          expect(page).to_not have_selector(:link_or_button, 'Clear vote')
          expect(page).to_not have_selector(:link_or_button, 'Downvote')
        end
      end
    end
    context 'NOT an answer owner' do
      context 'for the first time' do
        before js: true do
          sign_in(user)
          visit question_path(question)
        end
        scenario 'upvotes the answer', js: true do
          within '.avotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content 1
          end
        end
        scenario 'downvotes the answer', js: true do
          within '.avotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content -1
          end
        end
      end
      context 'when already upvoted' do
        before js: true do
          sign_in(user)
          visit question_path(question)
          within '.avotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax
        end
        scenario 'upvotes the answer', js: true do
          within '.avotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content 1
          end
        end
        scenario 'downvotes the answer', js: true do
          within '.avotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content -1
          end
        end
        scenario 'clears vote for the answer', js: true do
          within '.avotebuttons' do
            find('.clearvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content 0
          end
        end
      end
      context 'when already downvoted' do
        before js: true do
          sign_in(user)
          visit question_path(question)
          within '.avotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax
        end
        scenario 'upvotes the answer', js: true do
          within '.avotebuttons' do
            find('.upvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content 1
          end
        end
        scenario 'downvotes the answer', js: true do
          within '.avotebuttons' do
            find('.downvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content -1
          end
        end
        scenario 'clears vote for the answer', js: true do
          within '.avotebuttons' do
            find('.clearvote').click
          end
          wait_for_ajax

          within '.answers' do
            expect(page.find('.votescore')).to have_content 0
          end
        end
      end
    end
  end

end