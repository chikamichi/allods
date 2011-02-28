class Character < ActiveRecord::Base
  belongs_to :user

  has_many :loot_statuses
  has_many :loot_machines, :through => :loot_statuses

  accepts_nested_attributes_for :loot_statuses, :loot_machines

  validates_presence_of :nickname
  # @todo: maybe build a LevelValidator
  validates_presence_of :level
  validates_numericality_of :level, :only_integer => true
  validates_inclusion_of :level, :in => 1..45

  expose_attributes :public   => [:nickname, :level, :created_at],
                    :show     => [:level, :created_at],
                    :editable => [:nickname, :level]

  scope :for, lambda { |user|
    { :conditions => { :user_id => user.id } }
  }

  scope :for_everyone_but, lambda { |user|
    { :conditions => ["user_id <> ?", user.id] }
  }
end
