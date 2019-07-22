require 'rails_helper'

feature 'User can create comments', %q{
  In order to provide additional information
  As an authenticated user
  I'd like to be able to create comments to answers and questions
} do

  given(:user) {create(:user)}
  given(:question) { create(:question, user: user) }

  context 'Creating comment to question' do

    context 'as authenticated user' do

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'with no errors', js: true do

        fill_in 'Your comment', with: 'Text of the comment'
        click_on 'Submit comment'
        expect(current_path).to eq question_path(question)
        within '.question' do
          within '.comments' do
            expect(page).to have_content 'Text of the comment'
          end
        end
      end

      scenario 'with errors', js: true do
        click_on 'Submit comment'
        expect(page).to_not have_content 'Text of the comment'
        within '.notice' do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    context 'As unauthenticated user', js: true do
      scenario 'does not see your comment field' do
        visit question_path(question)

        expect(page).to_not have_field 'Your comment'
      end
    end

  end

  context 'Creating comment to answer' do

    given!(:answer) { create(:answer, question: question, user: user) }

    context 'as authenticated user' do

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'with no errors', js: true do
        within "#answer-#{answer.id}" do
          fill_in 'Your comment', with: 'Text of the comment'
          click_on 'Submit comment'
          expect(current_path).to eq question_path(question)
          within '.comments' do
            expect(page).to have_content 'Text of the comment'
          end
        end
      end

      scenario 'with errors', js: true do
        within "#answer-#{answer.id}" do
          click_on 'Submit comment'
          expect(page).to_not have_content 'Text of the comment'
        end
        within '.notice' do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    context 'As unauthenticated user', js: true do
      scenario 'does not see your comment field' do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          expect(page).to_not have_field 'Your comment'
        end
      end
    end
  end
end