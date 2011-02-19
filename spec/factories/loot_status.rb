LootStatus.blueprint do
  association :character
  association :loot_machine

  status  { LootStatus::STATUS.sort_by{rand}.first }
  need    { |ls| ls.status == :need ? 1 : 0 }
  greed   { |ls| ls.status == :greed ? 1 : 0 }
  loyalty { 5 }
  score   { rand(10) - 5 }
end
