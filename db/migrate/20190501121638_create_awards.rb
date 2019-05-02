class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :name
      t.belongs_to :user
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
