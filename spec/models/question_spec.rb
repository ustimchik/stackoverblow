require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'list answers methods:' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:second_answer) { create(:answer, user: user, question: question) }
    let!(:third_answer) { create(:answer, user: user, question: question) }

    before do
      answer.update(best: true)
      answer.reload
    end

    describe 'best_answer' do
      it 'returns the only one best answer' do
        expect(question.best_answer.first.id).to eq(answer.id)
      end

      it 'returns a proper number of objects' do
        expect(question.best_answer.count).to eq(1)
      end
    end

    describe 'other_answers' do
      it 'returns a list of answer objects' do
        expect(question.other_answers.first).to be_an(Answer)
      end

      it 'returns a proper number of objects' do
        expect(question.other_answers.count).to eq(2)
      end
    end
  end
end