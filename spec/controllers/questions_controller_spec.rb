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
    context 'as logged on user' do
      before { login(user) }

      before { get :new }

      it 'creates a new question and assigns to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end
      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'as NOT logged on user' do

      before { get :new }

      it 'does not create a new question and does not assign it to @question' do
        expect(assigns(:question)).to_not be_a_new(Question)
      end
    end
  end

  describe 'GET #edit' do

    context 'as logged on user and NOT resource owner' do
      before { login(user) }
      before { get :edit, params: {id: question_test} }

      it 'does not render edit view' do
        expect(response).to_not render_template :edit
      end
    end

    context 'as logged on user and resource owner' do
      before { login(user) }
      before { question_test.update(user: user) }
      before { get :edit, params: {id: question_test} }

      it 'assigns question with id from params to @question' do
        expect(assigns(:question)).to eq question_test
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'as NOT logged on user' do
      before { get :edit, params: {id: question_test} }

      it 'does not assign question with id from params to @question' do
        expect(assigns(:question)).to_not eq question_test
      end

      it 'does not render edit view' do
        expect(response).to_not render_template :edit
      end
    end

  end

  describe 'POST #create' do

    context 'as logged on user' do
      before { login(user) }

      context 'with valid attributes' do

        it 'saves a new question object with valid user id' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
        end

        it 'redirects to show question with specified ID' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end

        it 'creates a new subscription' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Subscription, :count).by(1)
        end

        it 'associates the subscription with user' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(user.subscriptions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not create a new Question object' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end
        it 'renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'as NOT logged on user' do

      it 'does not save a new question object with valid user id' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(user.questions, :count)
      end

      it 'does not redirect to show question with specified ID' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to_not redirect_to assigns(:question)
      end
    end

  end

  describe 'PATCH #update' do

    context 'as logged on user' do
      before { login(user) }

      context 'as question author' do
        before {question_test.update(user: user)}

        context 'with valid attributes' do

          it 'assigns the requested question to @question' do
            patch :update, params: { id: question_test, question: attributes_for(:question) }, format: :js
            expect(assigns(:question)).to eq question_test
          end

          it 'changes question attributes' do
            patch :update, params: { id: question_test, question: { title: 'test title', body: 'test body' } }, format: :js
            question_test.reload

            expect(question_test.title).to eq 'test title'
            expect(question_test.body).to eq 'test body'
          end

          it 'renders update js' do
            patch :update, params: { id: question_test, question: attributes_for(:question) }, format: :js
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: question_test, question: attributes_for(:question, :invalid) }, format: :js }

          it 'does not change question' do
            question_test.reload

            expect(question_test.title).to eq 'Question title'
            expect(question_test.body).to eq 'Question body'
          end

          it 'renders update js' do
            expect(response).to render_template :update
          end
        end
      end

      context 'as NOT question author' do
        before { patch :update, params: { id: question_test, question: attributes_for(:question) }, format: :js }

        it 'does not change question' do
          question_test.reload

          expect(question_test.body).to eq 'Question body'
        end

        it 'does not render update template' do
          expect(response).to_not render_template :update
        end
      end
    end

    context 'as NOT logged on user' do

      it 'does not assign the requested question to @question' do
        patch :update, params: { id: question_test, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to_not eq question_test
      end

      it 'does not change question attributes' do
        patch :update, params: { id: question_test, question: { title: 'test title', body: 'test body' } }, format: :js
        question_test.reload

        expect(question_test.body).to_not eq 'test body'
      end

      it 'does not render update js' do
        patch :update, params: { id: question_test, question: attributes_for(:question) }, format: :js
        expect(response).to_not render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'as logged on user' do
      before { login(user) }

      context 'as question author' do
        let!(:question_test) {create(:question, user: user) }
        let(:delete_answer) {delete :destroy, params: {id: question_test}}

        it 'deletes the question' do
          expect{delete_answer}.to change(Question, :count).by(-1)
        end

        it 'redirects to all questions' do
          expect(delete_answer).to redirect_to questions_path
        end
    end

      context 'as NOT question author' do
        let!(:question_test) {create(:question, user: create(:user)) }
        let(:delete_answer) {delete :destroy, params: { id: question_test}}

        it 'does not delete the question' do
          expect{delete_answer}.to_not change(Question, :count)
        end

        it 'does not redirect to all questions' do
          expect(delete_answer).to_not redirect_to question_test
        end
      end

      end

    context 'as NOT logged on user' do
      let!(:question_test) {create(:question, user: create(:user)) }
      let(:delete_answer) {delete :destroy, params: { id: question_test}}

      it 'does not delete the question' do
        expect{delete_answer}.to_not change(Question, :count)
      end

      it 'does not redirect to all questions' do
        expect(delete_answer).to_not redirect_to question_test
      end
    end
  end

  context 'votable' do
    let!(:voteable_item) { create(:question, user: user) }
    it_behaves_like "Voteable Controller"
  end

end
