require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question_test) { create(:question) }
  let(:user) {create(:user)}

  describe 'GET #index' do
    let(:questions) { create_list(:question, 4) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question_test} }

    it 'assigns question with id from params to @question' do
      expect(assigns(:question)).to eq question_test
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'creates a new question and assigns to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: {id: question_test} }

    it 'assigns question with id from params to @question' do
      expect(assigns(:question)).to eq question_test
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'valid attributes' do

      it 'creates a new Question object' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show question with specified ID' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'invalid attributes' do
      it 'does not create a new Question object' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 'renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question_test, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question_test
      end

      it 'changes question attributes' do
        patch :update, params: { id: question_test, question: { title: 'test title', body: 'test body' } }
        question_test.reload

        expect(question_test.title).to eq 'test title'
        expect(question_test.body).to eq 'test body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question_test, question: attributes_for(:question) }
        expect(response).to redirect_to question_test
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question_test, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question_test.reload

        expect(question_test.title).to eq 'Question title'
        expect(question_test.body).to eq 'Question body'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question_test) { create(:question) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question_test } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question_test }
      expect(response).to redirect_to questions_path
    end
  end
end
