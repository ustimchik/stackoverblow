require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

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
    let (:question_test) { create(:question) }

    before { get :show, params: {id: question_test} }

    it 'loads the resource with specified id from params' do
      expect(assigns(:question)).to eq question_test
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

end
