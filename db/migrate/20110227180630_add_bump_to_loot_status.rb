class AddBumpToLootStatus < ActiveRecord::Migration
  def self.up
    add_column :loot_statuses, :bump, :string
  end

  def self.down
    remove_column :loot_statuses, :bump
  end
end
