class AddSteamIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :steam_id, :string
  end
end
