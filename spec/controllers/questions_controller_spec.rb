require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let (:question_test) { create(:question) }

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
    before { get :new }

    it 'creates a new question and assigns to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do

    before { get :edit, params: {id: question_test} }

    it 'assigns question with id from params to @question' do
      expect(assigns(:question)).to eq question_test
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

end
