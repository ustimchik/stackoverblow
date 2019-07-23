require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy)}

  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  context 'votable' do
    let!(:voteable_item) { create(:question) }
    it_behaves_like "Voteable Model"
  end

  describe 'subscribe' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    it 'creates a new subscription' do
      expect{ question.subscribe(user) }.to change(Subscription, :count).by(1)
    end

    it 'associates subscription with a given question' do
      expect{ question.subscribe(user) }.to change(question.subscriptions, :count).by(1)
    end

    it 'associates subscription with a given user' do
      expect{ question.subscribe(user) }.to change(user.subscriptions, :count).by(1)
    end

    context 'as callback after create' do
      subject { build(:question, user: user) }

      it 'subscribes author after creating a new object' do
        expect{ (subject.save!) }.to change(user.subscriptions, :count).by(1)
      end
    end
  end
end