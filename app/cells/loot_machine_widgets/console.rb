module LootMachineWidgets
  class Console < Apotomo::Widget
    responds_to_event :change, :with => :refresh

    has_widgets do |console|
      setup!

      # LootStatusWidgets
      unless @loot_machine.loot_statuses.empty?
        @loot_machine.loot_statuses.each do |loot_status|
          console << widget('loot_status_widgets/line',
                            "loot_status_line_#{loot_status.id}",
                            :loot_status_id => loot_status.id)
        end
      end
    end

    def display
      setup!
      render
    end

    def inner_content 
      setup!
      render
    end


    def refresh
      setup!

      # actually, perform updates and run callbacks to compute LootStatus
      # evolutions for everyone, then render the whole console again.

      ls = LootStatus.find(params[:loot_status_id])
      ls.update_attribute(params[:loot_status_metadata].to_sym, params[:value])
      
      render :view => :inner_content
    end

    private

    # Retrieve the proper LootMachine, using either the id set within
    # a controller or sent back with a request in the params hash
    # (options is merged to params).
    #
    def setup!
      logger.debug ">>>>>"
      logger.debug options.inspect
      @loot_machine = LootMachine.find options[:loot_machine_id]
    end
  end
end
