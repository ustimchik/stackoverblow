shared_examples_for 'Search Feature' do

  describe "category search", sphinx: true, js: true do
    given(:user) { create(:user, email: 'search@test.com') }
    given(:question) { create(:question, body: "test_question", user: user) }
    given(:answer) { create(:answer, question: question, body: "test_answer") }
    given(:comment) { create(:comment, commentable: answer, body: "test_comment") }
    given!(:rules) {{
        'All': {query: question.body, name: "Question: #{question.title}", url: question_path(question)},
        'User': {query: user.email, name: "User: #{user.email}", url: user_path(user)},
        'Question': {query: question.body, name: "Question: #{question.title}", url: question_path(question)},
        'Answer': {query: answer.body, name: "Answer: #{answer.body.truncate(80)}", url: question_path(answer.question)},
        'Comment': {query: comment.body, name: "Comment: #{comment.body.truncate(80)}", url: question_path(comment.commentable.question)}
    }}

    scenario "testing", sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        visit questions_path
        fill_in 'query', with: rules["#{category}".to_sym][:query]
        select "#{category}", from: 'category'
        click_on 'Search'

        expect(page).to have_link rules["#{category}".to_sym][:name], href: rules["#{category}".to_sym][:url]
      end
    end
  end
end