require 'rails_helper'

RSpec.describe Services::Search do
  let(:query) {'test'}
  let(:category_all) { 'All' }
  let(:categories_rest) { %w[Question Answer Comment User] }
  let(:categories_wrong) { ['Godzilla', 'catzilla', 123] }

  describe '.perform' do
    it 'calls search on ThinkingSphinx if category is all' do
      allow(ThinkingSphinx::Query).to receive(:escape).with(query).and_return(query)
      expect(ThinkingSphinx).to receive(:search).with(query)
      subject.perform(query, category_all)
    end

    it 'calls search on class if category is one of the correct' do
      categories_rest.each do |category|
        allow(ThinkingSphinx::Query).to receive(:escape).with(query).and_return(query)
        expect(category.constantize).to receive(:search).with(query)
        subject.perform(query, category)
      end
    end

    it 'returns nil if query is empty' do
      expect(subject.perform('', category_all)).to be nil
    end

    it 'returns nil if category is wrong' do
      categories_wrong.each do |category|
        expect(subject.perform(query, category)).to be nil
      end
    end

    it 'returns nil if category is nil' do
      expect(subject.perform(query, nil)).to be nil
    end

    it 'returns nil if query nil' do
      expect(subject.perform(nil, category_all)).to be nil
    end
  end
end
