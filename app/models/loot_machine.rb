class LootMachine < ActiveRecord::Base
  has_many :loot_statuses
  has_many :characters, :through => :loot_statuses, :validate => false

  has_paper_trail :only => :bump, :meta => { :bump => Proc.new { |loot_machine| loot_machine.bump } }

  validates_presence_of :title

  accepts_nested_attributes_for :loot_statuses, :characters, :allow_destroy => true

  expose_attributes :public   => [:title, :description],
                    :show     => [:description],
                    :editable => [:title, :description]

  # Save a new version of the LootMachine. This will save versions
  # for each associated LootStatus as well.
  #
  # Use the #bump attribute, which value is synchronized, to match
  # versions between the two models. The bump attribute store the date
  # the bump operation is performed as a string representation of the
  # timestamped datetime (eg. "1298833981").
  #
  # @example
  #
  #   lm = LootMachine.last
  #   lm.udpate_attribute # make some modifs
  #   lm.save
  #
  #   # create a new version
  #   lm.bump!
  #
  #   # ensure matching versions
  #   lm.versions.last.bump == lm.bump # => true
  #   lm.loot_statuses.last.versions.bump == lm.bump # => true
  #
  # @param [Hash] params ({})
  # @return [Bignum] the bump timestamp
  #
  def bump!(params = {})
    time = Time.now.to_i.to_s

    # bump the LootMachine
    update_attribute(:bump, time)

    # create versions for each LootStatus record
    loot_statuses.each do |loot_status|
      loot_status.update_attribute(:bump, time)
    end

    return time
  end

  def version_at
    obj = super
    
    # fetch all matching LootStatus
    obj.loot_statuses = Version.where(:item_type => 'LootStatus', :bump => obj.bump).map(&:reify)
  
    return obj
  end
end
