class AddGistFlagToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :gist, :boolean, default: false
  end
end