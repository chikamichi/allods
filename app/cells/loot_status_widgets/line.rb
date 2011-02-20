module LootStatusWidgets
  class Line < Apotomo::Widget
    def display
      setup!
      render
    end

    private

    def setup!
      @loot_status = options[:loot_status]
    end
  end
end
