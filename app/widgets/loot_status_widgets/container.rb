module LootStatusWidgets
  class ContainerWidget < AllodsWidget
    has_widgets do |me|
      setup!

      @loot_statuses.each do |loot_status|
        me << widget('loot_status_widgets/line',
                     "loot_status_line_#{loot_status.id}",
                     :loot_status_id => loot_status.id)
      end
    end

    def display
      setup!
      render
    end

    private

    def setup!
      super
      @loot_statuses = LootStatus.where(:character_id => options[:character_id])
    end
  end
end
