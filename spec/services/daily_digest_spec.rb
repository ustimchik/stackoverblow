require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let(:users) { create_list(:user, 3) }
  let!(:questions) { create_list(:question, 5, user: users.first) }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original }
    subject.send_digest
  end
end