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

    context 'for the first time' do
      it 'marks answer best' do
        expect(answer).to be_best
      end

      it 'makes sure only one answer is best' do
        expect(question.answers.where(best: true).count).to eq(1)
      end
    end

    context 'when other answer already marked as best' do

      before do
        second_answer.markbest
        second_answer.reload
      end

      it 'marks second answer best' do
        expect(second_answer).to be_best
      end

      it 'makes sure only one answer is best' do
        expect(question.answers.where(best: true).count).to eq(1)
      end
    end
  end
end

