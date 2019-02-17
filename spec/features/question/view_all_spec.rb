require 'rails_helper'

feature 'User can view all questions', %q{
  In order to see if I can help or find some info
  As a guest or authenticated user
  I'd like to be able to review the list of all questions
} do

  given!(:questions) { create_list(:question, 3)}
  scenario 'Any user is able to view list of all questions' do

    visit questions_path
    questions.each do |q|
      expect(page).to have_link q.title
    end
  end
end