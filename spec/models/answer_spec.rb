require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let!(:second_answer) { create(:answer, user: user, question: question) }

  it 'has many attached files' do
    expect(answer.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
  # context with best flag set to false was omitted as this should be handled by the database
  # where false is set by default, e.g. second let! would fail if that is not working fine
  describe 'validates answer uniqueness scoped to question' do
    it 'makes sure only one answer can be marked true' do
      answer.markbest
      second_answer.best = true
      expect(second_answer).to be_invalid
    end
  end

  describe '.markbest' do

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

  context 'votable' do
    let!(:voteable_item) { create(:answer) }
    it_behaves_like "Voteable Model"
  end
end