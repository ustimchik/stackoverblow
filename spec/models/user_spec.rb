require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy)}
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.author_of' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'returns true when author' do
      expect(user).to be_author_of(question)
    end

    it 'returns false when not an author' do
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

  describe '.subscription_for' do
    let(:user) { create (:user) }
    let(:other_user) { create (:user) }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    it 'returns subscription for the provided question if exists' do
      expect(user.subscription_for(question)).to eq subscription
    end

    it 'returns nil when subscription for the provided question does not exist' do
      expect(other_user.subscription_for(question)).to be_falsey
    end
  end
end