require 'rails_helper'

RSpec.describe User, type: :model do
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
end
