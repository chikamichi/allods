class AddBumpToLootMachine < ActiveRecord::Migration
  def self.up
    add_column :loot_machines, :bump, :string
  end

  def self.down
    remove_column :loot_machines, :bump
  end
end
