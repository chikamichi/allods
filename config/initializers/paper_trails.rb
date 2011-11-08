class Version < ActiveRecord::Base
  #markdownize! :description

  alias :legacy_reify :reify
  def reify
    case item_type.to_s
    when 'LootMachine' then
      # TODO: maybe add support for Character versioning?

      obj = legacy_reify
      # One must clone the record, for overriding the association will erase
      # the record's data.
      loot_machine = obj.clone

      # fetch all matching LootStatus and restore the has_many association
      loot_statuses = Version.where(:item_type => 'LootStatus', :bump => bump)

      loot_statuses.map!(&:legacy_reify)
      loot_statuses.map do |loot_status|
        loot_status.loot_machine = loot_machine
      end

      loot_machine.loot_statuses = loot_statuses

      return loot_machine
    else
      legacy_reify
    end
  end
end
