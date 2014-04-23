class ChangeDeckFromStringToTextForGames < ActiveRecord::Migration
  def up
    change_column :games, :deck, :text
  end
  
  def down
    change_column :games, :deck, :string
  end
end
