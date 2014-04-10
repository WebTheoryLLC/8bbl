class AddAbbrToPlatform < ActiveRecord::Migration
  def change
    add_column :platforms, :abbr, :string
  end
end
