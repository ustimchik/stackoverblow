require 'rails_helper'

RSpec.describe Link, type: :model do

  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validates url format for link URL' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'with wrong input' do
      question.links.new({'name':'testname', 'url': 'random string'})
      expect(question.links.first).to be_invalid
    end

    it 'with correct input' do
      question.links.new({'name':'testname', 'url': 'https://google.com'})
      expect(question.links.first).to be_valid
    end
  end
end
