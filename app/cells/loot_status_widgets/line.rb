module LootStatusWidgets
  class Line < Apotomo::Widget
    def display
      setup!
      render
    end

    private

    def setup!
      # Beware! You got to make a #find request here and not just
      # pass in the object through :loot_status => loot_status in the
      # parent widget, that is:
      # 
      #   @loot_status = options[:loot_status]
      #
      # because if you do so, then @loot_status will not be updated when
      # the parent widget ask for update :state => :display, for instance!
      # So, basically, always perform a fresh query to fetch the objects
      # used for rendering.
      #
      @loot_status  = LootStatus.find options[:loot_status_id]
      @loot_machine = @loot_status.loot_machine
      @no_js        = options[:no_js]
    end
  end
end
