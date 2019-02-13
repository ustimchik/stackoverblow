require 'rails_helper'

feature 'User can view question with associated answers', %q{
  In order to see the solutions
  As a guest or authenticated user
  I'd like to be able to view each question with its answers
} do

  given(:question) { create(:question_with_answers, answers_count: 3) }
  scenario 'Any user is able to view question with answers' do

    visit question_path(question)
    question.answers.each {|answer| expect(page).to have_content answer.body}
  end
end