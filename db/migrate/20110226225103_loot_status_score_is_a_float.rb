class LootStatusScoreIsAFloat < ActiveRecord::Migration
  def self.up
    change_column :loot_statuses, :score, :float, :default => 0
  end

  def self.down
    change_column :loot_statuses, :score, :string
  end
end
