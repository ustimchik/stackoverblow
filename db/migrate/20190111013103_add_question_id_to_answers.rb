class AddQuestionIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :answers, :question, foreign_key: true
  end
end
