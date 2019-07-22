require 'rails_helper'

RSpec.describe Services::QuestionUpdates do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, user: user, question: question) }

  it 'sends new answer if user not an answer author' do
    expect(QuestionUpdatesMailer).to receive(:send_new_answer).with(user, answer).and_call_original
    subject.send_new_answer(answer)
  end

  it 'does not send a new answer if user is an answer author' do
    answer.update(user: user)
    expect(QuestionUpdatesMailer).to_not receive(:send_new_answer)
    subject.send_new_answer(answer)
  end
end