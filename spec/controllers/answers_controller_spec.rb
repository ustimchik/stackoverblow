require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:answer_test) { create(:answer) }

  describe 'GET #index' do
    let (:question) { create(:question_with_answers, answers_count: 15) }

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

end
