require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:answer_test) { create(:answer) }
  let (:question) { create(:question_with_answers, answers_count: 3) }
  let (:user) { create(:user) }

  describe 'POST #create' do

    let(:create_answer) { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }

    context 'as logged on user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'creates a new answer object for a given Question' do
          expect { create_answer }.to change(question.answers, :count).by(1)
        end

        it 'saves the new answer object with valid user.id' do
          expect { create_answer }.to change(user.answers, :count).by(1)
        end

        it 'renders create-js' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not create a new Answer object for a given Question' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js }.to_not change(question.answers, :count)
        end
        it 'renders create-js' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js
          expect(response).to render_template :create
        end
      end
    end

  context 'as NOT logged on user' do
    it 'does not create a new Answer object for a given Question' do
      expect{create_answer}.to_not change(question.answers, :count)
    end
  end
  end

  describe 'PATCH #update' do

    context 'as logged on user' do
      before { login(user) }

      context 'as answer author' do
        before {answer_test.update(user: user)}

        context 'with valid attributes' do

          before { patch :update, params: { id: answer_test, answer: { body: 'test body' }}, format: :js }

          it 'assigns the requested answer to @answer' do
            expect(assigns(:answer)).to eq answer_test
          end

          it 'changes answer attributes' do
            answer_test.reload

            expect(answer_test.body).to eq 'test body'
          end

          it 'renders update-js' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          let!(:answer_saved) { answer_test.dup }
          before { patch :update, params: { id: answer_test, answer: attributes_for(:answer, :invalid)}, format: :js  }

          it 'does not change answer' do
            answer_test.reload
            expect(answer_test.body).to eq answer_saved.body
          end

          it 'renders update-js' do
            expect(response).to render_template :update
          end
        end
      end

      context 'as NOT answer author' do
        let!(:answer_saved) { answer_test.dup }
        before { patch :update, params: { id: answer_test, answer: attributes_for(:answer, :invalid)}, format: :js  }

        it 'does not change answer' do
          answer_test.reload
          expect(answer_test.body).to eq answer_saved.body
        end

        it 'renders update-js' do
          expect(response).to render_template :update
        end
      end
    end

    context 'as NOT logged on user' do
      let!(:answer_saved) { answer_test.dup }
      before { patch :update, params: { id: answer_test, answer: attributes_for(:answer)}, format: :js }

      it 'does not change answer' do
        answer_test.reload
        expect(answer_test.body).to eq answer_saved.body
      end

      it 'does not render update template' do
        expect(response).to_not render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question_with_answers, answers_count: 1) }
    let(:answer) { question.answers.first }
    let(:delete_answer) { delete :destroy, params: { id: answer }, format: :js }

    context 'as logged on user' do
      before { login(user) }

      context 'as answer owner' do
        before {answer.update(user: user)}

        it 'deletes the answer from the database' do
          expect{delete_answer}.to change(Answer, :count).by(-1)
        end

        it 'redirects to previously stored @question' do
          expect(delete_answer).to render_template :destroy
        end
      end

      context 'as NOT answer owner' do
        it 'does not delete the answer from the database' do
          expect{delete_answer}.to_not change(Answer, :count)
        end

        it 'renders destroy template' do
          expect(delete_answer).to render_template :destroy
        end
      end
    end

    context 'as NOT logged on user' do
      it 'does not delete the answer from the database' do
        expect{delete_answer}.to_not change(Answer, :count)
      end

      it 'does not render destroy template' do
        expect(delete_answer).to_not render_template :destroy
      end
    end
  end

  describe 'PATCH #markbest' do
    let!(:question) { create(:question, user: user) }
    let(:other_user) { create(:user) }
    let(:answer_first) { create(:answer, question: question, user: other_user) }
    let(:answer_second) { create(:answer, question: question, user: user, best: true) }
    let(:markbest) { post :markbest, params: { id: answer_first }, format: :js }

    context 'as question owner' do
      before { login(user) }

      it 'assigns the requested answer to @answer' do
        markbest
        expect(assigns(:answer)).to eq answer_first
      end

      it 'assigns the @question' do
        markbest
        expect(assigns(:question)).to eq question
      end

      it 'marks answer best in database' do
        markbest

        answer_first.reload
        expect(answer_first.best).to be true
      end

      it 'renders markbest js' do
        markbest
        expect(response).to render_template :markbest
      end
    end

    context 'as NOT question owner' do
      before { login(other_user) }

      it 'does not mark answer best in database' do
        markbest

        answer_first.reload
        expect(answer_first.best).to be_falsey
      end

      it 'renders markbest js' do
        markbest
        expect(response).to render_template :markbest
      end
    end
  end
end
