class Bootstrap < ActiveRecord::Migration
  def self.up
    # Users own characters
    create_table :characters do |t|
      t.string  :nickname,      :null => false
      t.integer :level,         :null => false
      t.integer :user_id

      t.timestamps
    end

    # A loot machine is a raid, an event… which gathers
    # characters for several runs, and keep tracks of their loots
    create_table :loot_machines do |t|
      t.string :title,          :null => false
      t.text   :description
      t.string :metadata

    end

    # Actually, loots are monitored through a joined model
    create_table :loot_statuses do |t|
      t.references :character
      t.references :loot_machine
      t.string     :status,     :null => false, :default => "need"
      t.integer    :need,       :null => false, :default => 0
      t.integer    :greed,      :null => false, :default => 0
      t.integer    :loyalty,    :null => false, :default => 0
      t.string     :score,      :null => false, :default => 0

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :characters, :user_id
    add_index :loot_statuses, :character_id
    add_index :loot_statuses, :loot_machine_id
  end

  def self.down
    drop_table :characters
    drop_table :loot_machines
    drop_table :loot_statuses
  end
end
