require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:answer_test) { create(:answer) }
  let (:question) { create(:question_with_answers, answers_count: 3) }
  let (:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    let(:create_answer) { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }

    context 'valid attributes' do

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

    context 'invalid attributes' do
      it 'does not create a new Answer object for a given Question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js }.to_not change(question.answers, :count)
      end
      it 'renders create-js' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer_test, answer: attributes_for(:answer)}, format: :js
        expect(assigns(:answer)).to eq answer_test
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer_test, answer: { body: 'test body' }}, format: :js
        answer_test.reload

        expect(answer_test.body).to eq 'test body'
      end

      it 'renders update-js' do
        patch :update, params: { id: answer_test, answer: attributes_for(:answer)}, format: :js
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

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question_with_answers, answers_count: 1)}
    let(:answer) { question.answers.first }
    let(:delete_answer) {delete :destroy, params: { id: answer}}

    context 'as answer owner' do

      before {answer.update(user: user)}

      it 'deletes the answer from the database' do
        expect{delete_answer}.to change(Answer, :count).by(-1)
      end

      it 'redirects to previously stored @question' do
        expect(delete_answer).to redirect_to question
      end
    end

    context 'as NOT answer owner' do
      it 'does not delete the answer from the database' do
        expect{delete_answer}.to_not change(Answer, :count)
      end

      it 'redirects to previously stored @question' do
        expect(delete_answer).to redirect_to question
      end
    end
  end
end
