module LootStatusWidgets
  class LineWidget < AllodsWidget
    def display
      setup!
      render
    end

    private

    def setup!
      @loot_status  = LootStatus.find options[:loot_status_id]
      @loot_machine = @loot_status.loot_machine
      @no_js        = options[:no_js]
    end
  end
end
