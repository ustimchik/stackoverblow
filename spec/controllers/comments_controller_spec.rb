require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let (:user) { create(:user) }
  let (:question) { create(:question) }
  let (:answer) { create(:answer, question: question) }
  let (:comment) { create(:comment, commentable: answer) }

  describe 'POST #create' do

    let(:create_comment) { post :create, params: { comment: attributes_for(:comment), commentable: answer, answer_id: answer.id }, format: :js }

    context 'as logged on user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'creates a new comment object' do
          expect{create_comment}.to change(answer.comments, :count).by(1)
        end

        it 'saves the new comment object with valid user.id' do
          expect{create_comment}.to change(user.comments, :count).by(1)
        end

        it 'sets proper css selector' do
          create_comment
          expect(assigns(:css)).to eq(".answer")
        end

        it 'renders create-js' do
          create_comment
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not create a new comment object' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), commentable: answer, answer_id: answer.id }, format: :js }.to_not change(answer.comments, :count)
        end
        it 'renders create-js' do
          post :create, params: { comment: attributes_for(:comment, :invalid), commentable: answer, answer_id: answer.id }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'as NOT logged on user' do
      it 'does not create a new comment object for a given Question' do
        expect{create_comment}.to_not change(answer.comments, :count)
      end
    end
  end

  describe 'PATCH #update' do

    context 'as logged on user' do
      before { login(user) }

      context 'as comment author' do
        before {comment.update(user: user)}

        context 'with valid attributes' do

          before { patch :update, params: { id: comment, comment: { body: 'test body' }}, format: :js }

          it 'assigns the requested comment to @comment' do
            expect(assigns(:comment)).to eq comment
          end

          it 'changes comment attributes' do
            comment.reload

            expect(comment.body).to eq 'test body'
          end

          it 'renders update-js' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          let!(:comment_saved) { comment.dup }
          before { patch :update, params: { id: comment, comment: attributes_for(:comment, :invalid)}, format: :js  }

          it 'does not change answer' do
            comment.reload
            expect(comment.body).to eq comment_saved.body
          end

          it 'renders update-js' do
            expect(response).to render_template :update
          end
        end
      end

      context 'as NOT answer author' do
        let!(:comment_saved) { comment.dup }
        before { patch :update, params: { id: comment, comment: attributes_for(:comment, :invalid)}, format: :js  }

        it 'does not change answer' do
          comment.reload
          expect(comment.body).to eq comment_saved.body
        end

        it 'renders update-js' do
          expect(response).to render_template :update
        end
      end
    end

    context 'as NOT logged on user' do
      let!(:comment_saved) { comment.dup }
      before { patch :update, params: { id: comment, comment: attributes_for(:comment)}, format: :js }

      it 'does not change answer' do
        comment.reload
        expect(comment.body).to eq comment_saved.body
      end

      it 'does not render update template' do
        expect(response).to_not render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let! (:comment) { create(:comment, commentable: answer) }
    let (:delete_comment) { delete :destroy, params: { id: comment }, format: :js }

    context 'as logged on user' do
      before { login(user) }

      context 'as comment owner' do
        before {comment.update(user: user)}

        it 'deletes the comment' do
          expect{delete_comment}.to change(Comment, :count).by(-1)
        end

        it 'renders destroy js' do
          expect(delete_comment).to render_template :destroy
        end
      end

      context 'as NOT comment owner' do
        it 'does not delete the comment' do
          expect{delete_comment}.to_not change(Comment, :count)
        end

        it 'renders destroy template' do
          expect(delete_comment).to render_template :destroy
        end
      end
    end

    context 'as NOT logged on user' do
      it 'does not delete the comment from the database' do
        expect{delete_comment}.to_not change(Comment, :count)
      end

      it 'does not render destroy template' do
        expect(delete_comment).to_not render_template :destroy
      end
    end
  end

end
