require 'rails_helper'

RSpec.describe Services::QuestionUpdates, type: :job do
  let!(:author){ create(:user) }
  let!(:question) { create(:question, user: author)}
  let!(:users) { create_list(:user, 5) }
  let!(:answer){ create(:answer, question: question, user: author) }

  it 'sends new answer notification to subscribed users' do
    users.each do |user|
      question.subscribe(user)
      expect(QuestionUpdatesMailer).to receive(:send_new_answer).with(user, answer).and_call_original
    end
    subject.send_new_answer(answer)
  end

  it 'does not send notification to not subscribed user' do
    users.each do |user|
      expect(QuestionUpdatesMailer).to_not receive(:send_new_answer).with(user, answer)
    end
    subject.send_new_answer(answer)
  end

  it 'does not send notification to answer author' do
    question.subscribe(author)
    expect(QuestionUpdatesMailer).to_not receive(:send_new_answer).with(author, answer)
    subject.send_new_answer(answer)
  end
end