class LootStatus < ActiveRecord::Base
  belongs_to :character
  belongs_to :loot_machine

  # Loot actions. Given its current score and the score of the other
  # member of a group, the character has a loot status enforced by the
  # group looting strategy/scheme.
  STATUS = [:need, :greed]
end
