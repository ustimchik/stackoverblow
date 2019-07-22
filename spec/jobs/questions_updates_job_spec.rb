require 'rails_helper'

RSpec.describe QuestionsUpdatesJob, type: :job do
  let(:service) { double('Service::DailyDigest') }
  let(:answer) { double('Answer') }

  before do
    allow(Services::QuestionUpdates).to receive(:new).and_return(service)
  end

  it 'calls Services::QuestionsUpdates#send_new_answer' do
    expect(service).to receive(:send_new_answer).with(:answer)
    QuestionsUpdatesJob.perform_now(:answer)
  end
end