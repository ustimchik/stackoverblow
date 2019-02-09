class AddUserIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :answers, :user, foreign_key: true
  end
end
