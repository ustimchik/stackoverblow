class AddDeltaIndices < ActiveRecord::Migration[5.2]
  TO_CHANGE = [:users, :questions, :answers, :comments]

  def self.up
    TO_CHANGE.each do |table|
      add_column table, :delta, :boolean, default: true, null: false
      add_index  table, :delta
    end
  end
end