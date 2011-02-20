module LootMachineWidgets
  class Console < Apotomo::Widget
    #has_widgets do |console|
      #setup!
      #@loot_machine.loot_statuses.each do |loot_status|
        #console << widget('loot_status_widgets/line', "loot_status_line_#{loot_status.id}", :loot_status => loot_status)
      #end
    #end

    def display
      setup!
      render
    end

    private

    def setup!
      @loot_machine = options[:loot_machine]
    end
  end
end
