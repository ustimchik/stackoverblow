require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_presence_of :body }

  describe 'uniqueness validation of best flag scoped to question_id' do
    #For some reason this test returns weird output and fails.
    context 'if best set to true' do
      before { allow(subject).to receive(:best).and_return(true) }
      it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
    end

    context 'if best set to false' do
      before { allow(subject).to receive(:best).and_return(false) }
      it { should_not validate_uniqueness_of(:best) }
    end
  end

  describe '.markbest' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:second_answer) { create(:answer, user: user, question: question) }

    before do
      answer.markbest
      answer.reload
    end

    it 'marks answer the only best for the first time' do
      expect(answer.best).to be true
      expect(question.answers.where(best: true).count).to eq(1)
    end

    it 'marks another answer making it the only best' do
      second_answer.markbest
      second_answer.reload
      expect(second_answer.best).to be true
      expect(question.answers.where(best: true).count).to eq(1)
    end
  end
end

