require 'sphinx_helper'

feature 'User can search through records', %q{
  In order to find the required info
  As any user
  I'd like to be able to search through all or specific type of records
} do

  context 'Any user can search in all categories' do
    let!(:category) { 'All' }
    it_behaves_like "Search Feature"
  end

  context 'Any user can search in Questions' do
    let!(:category) { 'Question' }
    it_behaves_like "Search Feature"
  end

  context 'Any user can search in Answers' do
    let!(:category) { 'Answer' }
    it_behaves_like "Search Feature"
  end

  context 'Any user can search in Comments' do
    let!(:category) { 'Comment' }
    it_behaves_like "Search Feature"
  end

  context 'Any user can search in Users' do
    let!(:category) { 'User' }
    it_behaves_like "Search Feature"
  end

  scenario 'query empty - alert generated', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path
      fill_in 'query', with: ''
      click_on 'Search'

      expect(page).to have_content 'The search query is empty or wrong category'
    end
  end

  scenario 'nothing found', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path
      fill_in 'query', with: 'query'
      click_on 'Search'

      expect(page).to have_content 'No results found'
    end
  end
end