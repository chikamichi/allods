class AddArchetypeAndRoleToCharacter < ActiveRecord::Migration
  def self.up
    add_column :characters, :archetype, :string
    add_column :characters, :role, :string
  end

  def self.down
    remove_column :characters, :role
    remove_column :characters, :archetype
  end
end
