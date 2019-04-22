require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    let (:user) { create(:user) }
    let (:wrong_user) { create(:user) }
    let (:question) { create(:question, :with_attachment, user: user) }
    let! (:answer) { create(:answer, :with_attachment, question: question, user: user) }
    let (:delete_attachment_question) { delete :destroy, params: { id: question.files.first, question: question }, format: :js }
    let (:delete_attachment_answer) { delete :destroy, params: { id: answer.files.first, question: question }, format: :js }

    context 'as logged in user' do
      before { login(user) }
      context 'on question' do
        context 'as owner' do

          it 'deletes the attachment from the database' do
            expect{delete_attachment_question}.to change(ActiveStorage::Attachment, :count).by(-1)
          end

          it 'renders destroy js' do
            expect(delete_attachment_question).to render_template :destroy
          end
        end
        context 'as NOT owner' do
          before {question.update(user: wrong_user)}

          it 'does not delete the answer from the database' do
            expect{delete_attachment_question}.to_not change(ActiveStorage::Attachment, :count)
          end

          it 'renders destroy template' do
            expect(delete_attachment_question).to render_template :destroy
          end
        end
      end
      context 'on answer' do
        context 'as owner' do

          it 'deletes the attachment from the database' do
            expect{delete_attachment_answer}.to change(ActiveStorage::Attachment, :count).by(-1)
          end

          it 'renders destroy js' do
            expect(delete_attachment_answer).to render_template :destroy
          end
        end
        context 'as NOT owner' do
          before {answer.update(user: wrong_user)}

          it 'does not delete the answer from the database' do
            expect{delete_attachment_answer}.to_not change(ActiveStorage::Attachment, :count)
          end

          it 'renders destroy template' do
            expect(delete_attachment_answer).to render_template :destroy
          end
        end
      end
    end

    context 'as NOT logged in user' do
      context 'on question' do
        it 'does not delete the file attached to question from the database' do
          expect{delete_attachment_question}.to_not change(ActiveStorage::Attachment, :count)
        end

        it 'does not render destroy template' do
          expect(delete_attachment_question).to_not render_template :destroy
        end
      end
      context 'on answer' do
        it 'does not delete the file attached to answer from the database' do
          expect{delete_attachment_answer}.to_not change(ActiveStorage::Attachment, :count)
        end

        it 'does not render destroy template' do
          expect(delete_attachment_answer).to_not render_template :destroy
        end
      end
    end

  end
end
