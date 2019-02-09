require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:answer_test) { create(:answer) }
  let (:question) { create(:question_with_answers, answers_count: 3) }
  let (:user) {create(:user)}


  describe 'GET #index' do
    before { get :index, params: {question_id: question} }

    it 'populates an array of all answers for a given question' do
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: answer_test} }

    it 'assigns answer with id from params to @answer' do
      expect(assigns(:answer)).to eq answer_test
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { answer: attributes_for(:answer), question_id: question } }

    it 'creates a new answer and assigns to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'has an association with the @question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: {id: answer_test} }

    it 'assigns answer with id from params to @answer' do
      expect(assigns(:answer)).to eq answer_test
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'valid attributes' do

      it 'creates a new Answer object for a given Question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer)} }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show answer with specified ID' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'invalid attributes' do
      it 'does not create a new Answer object for a given Question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid)} }.to_not change(question.answers, :count)
      end
      it 'renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer_test, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer_test
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer_test, answer: { title: 'test title', body: 'test body' } }
        answer_test.reload

        expect(answer_test.title).to eq 'test title'
        expect(answer_test.body).to eq 'test body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer_test, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer_test
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer_test, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer_test.reload

        expect(answer_test.title).to eq 'MyString'
        expect(answer_test.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question_with_answers, answers_count: 1) }
    let(:delete_answer) {delete :destroy, params: { id: question.answers.first}}

    it 'assigns question to @question before deletion for future redirect' do
      delete_answer
      expect(assigns(:question)).to eq question
    end

    it 'deletes the answer from the database' do
      expect {delete_answer}.to change(Answer, :count).by(-1)
    end

    it 'redirects to previously stored @question' do
      expect(delete_answer).to redirect_to question
    end
  end
end
