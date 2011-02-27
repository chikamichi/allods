module LootMachineWidgets
  class ConsoleWidget < AllodsWidget
    responds_to_event :change, :with => :refresh

    has_widgets do |console|
      setup!

      unless @loot_machine.loot_statuses.empty?
        @loot_machine.loot_statuses.each do |loot_status|
          console << widget('loot_status_widgets/line',
                            "loot_status_line_#{loot_status.id}",
                            :loot_status_id => loot_status.id)
        end
      end
    end

    # @group States

    def display
      setup!
      render
    end

    def inner_content 
      setup!
      render
    end

    # @group Events


    def refresh(event)
      setup!

      # actually, perform updates and run callbacks to compute LootStatus
      # evolutions for everyone before updating. Maybe a transaction?

      ls = LootStatus.find(event[:loot_status_id])

      # update the edited metadata with the new value
      ls.update_attribute(event[:loot_status_metadata].to_sym, event[:value])

      # update the score
      ls.compute :score
      # update the status of each member of the loot machine
      @loot_machine.loot_statuses.each do |loot_status|
        loot_status.compute :status
      end
      
      render :view => :inner_content
    end

    # @endgroup

    private

    # Retrieve the proper LootMachine, using either the id set within
    # a controller or sent back with a request in the params hash
    # (options is merged to params).
    #
    def setup!
      @loot_machine = LootMachine.find options[:loot_machine_id]
    end
  end
end
