require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create :user }

    let(:question) { create :question, user: user }
    let(:another_question) { create :question, user: another_user }

    let(:answer) { create :answer, user: user, question: another_question }
    let(:another_answer) { create :answer, user: another_user, question: question }

    let(:comment) { create :comment, user: user, commentable: answer }
    let(:another_comment) { create :comment, user: another_user, commentable: answer }

    let(:file) { create :file, user: user, attachable: answer }
    let(:another_file) { create :file, user: another_user, attachable: answer }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'for question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, another_question }
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, another_question }
      it { should be_able_to :upvote, another_question }
      it { should_not be_able_to :upvote, question }
      it { should be_able_to :downvote, another_question }
      it { should_not be_able_to :downvote, question }
      it { should be_able_to :clearvote, another_question }
      it { should_not be_able_to :clearvote, question }
    end

    context 'for answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, another_answer }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, another_answer }
      it { should be_able_to :upvote, another_answer }
      it { should_not be_able_to :upvote, answer }
      it { should be_able_to :downvote, another_answer }
      it { should_not be_able_to :downvote, answer }
      it { should be_able_to :clearvote, another_answer }
      it { should_not be_able_to :clearvote, answer }

      context 'markbest' do
        let(:own_answer) { create :answer, user: user, question: question }

        it { should be_able_to :markbest, another_answer }
        it { should_not be_able_to :markbest, answer }
        it { should_not be_able_to :markbest, own_answer }
        it { should_not be_able_to :markbest, own_answer.update(question: another_question) }
      end
    end

    context 'for comment' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update, comment }
      it { should_not be_able_to :update, another_comment }
      it { should be_able_to :destroy, comment }
      it { should_not be_able_to :destroy, another_comment }
    end

    context 'for files' do
      let!(:answer_with_file) { create :answer, :with_attachment, user: user }
      let!(:another_answer_with_file) { create :answer, :with_attachment, user: another_user }

      it { should be_able_to :create, ActiveStorage::Attachment }
      it { should be_able_to :destroy, answer_with_file.files.first }
      it { should_not be_able_to :destroy, another_answer_with_file.files.first}
    end

    context 'for subscription' do
      let(:question) { create :question }
      let!(:subscription) { create :subscription, user: user, question: question }
      let!(:another_subscription) { create :subscription, user: another_user, question: question }

      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, subscription }
      it { should_not be_able_to :destroy, another_subscription }
    end
  end
end