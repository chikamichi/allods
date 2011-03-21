class AddRenderedDescriptionToLootMachine < ActiveRecord::Migration
  def self.up
    add_column :loot_machines, :rendered_description, :string
  end

  def self.down
    remove_column :loot_machines, :rendered_description
  end
end
