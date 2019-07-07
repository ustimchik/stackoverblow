require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards)}
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.author_of' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'as author' do
      expect(user).to be_author_of(question)
    end

    it 'as not author' do
      expect(other_user).not_to be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create (:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services:FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end