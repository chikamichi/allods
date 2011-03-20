module LootStatusWidgets
  class LineWidget < AllodsWidget
    build do |options|
      unless options.nil?
        AdminLineWidget if options[:user] && options[:user].admin?
      end
    end

    def display
      setup!
      render
    end

    private

    def setup!
      super
      @loot_status  = LootStatus.find options[:loot_status_id]
      @loot_machine = @loot_status.loot_machine
      @no_js        = options[:no_js]
    end
  end

  class AdminLineWidget < LineWidget
  end
end
