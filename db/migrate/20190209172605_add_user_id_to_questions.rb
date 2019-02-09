class AddUserIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :questions, :user, foreign_key: true
  end
end
