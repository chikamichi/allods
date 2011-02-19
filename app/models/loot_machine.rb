class LootMachine < ActiveRecord::Base
  has_many :loot_statuses
  has_many :characters, :through => :loot_statuses

  validates_presence_of :title

  accepts_nested_attributes_for :loot_statuses, :characters, :allow_destroy => true

  expose_attributes :public   => [:title, :description],
                    :show     => [:description],
                    :editable => [:title, :description]
end
