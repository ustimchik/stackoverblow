require 'rails_helper'

RSpec.describe Link, type: :model do

  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:question) { create(:question) }
  let(:link) { create(:link, linkable: question) }
  let(:gist_link) { create(:link, :gist, linkable: question) }

  describe 'validates url format for link URL' do

    it 'with wrong input' do
      question.links.new({'name':'testname', 'url': 'random string'})
      expect(question.links.first).to be_invalid
    end

    it 'with correct input' do
      question.links.new({'name':'testname', 'url': 'https://google.com'})
      expect(question.links.first).to be_valid
    end
  end

  describe 'method set_gist' do
    it 'sets gist flag to true for GIST URLs' do
      expect(gist_link).to be_gist
    end

    it 'does not not change the gist flag for ordinary URL' do
      expect(link).to_not be_gist
    end
  end

  describe 'method gist_js' do
    it 'returns URL with .js extension appended' do
      expect(gist_link.gist_js).to eq "#{gist_link.url}.js"
    end
  end
end