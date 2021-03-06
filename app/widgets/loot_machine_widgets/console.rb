module LootMachineWidgets
  class ConsoleWidget < AllodsWidget
    responds_to_event :change
    responds_to_event :plusOne

    build do |options|
      AdminConsoleWidget if options[:user] and options[:user].admin?
    end

    has_widgets do |console|
      setup!

      unless @loot_machine.loot_statuses.empty?
        @loot_machine.loot_statuses.each do |loot_status|
          console << widget('loot_status_widgets/line',
                            "loot_status_line_#{loot_status.id}",
                            :loot_status_id => loot_status.id,
                            :user => @user)
        end
      end
    end

    # @group States

    def display(opts = {})
      setup!
      render :locals => opts
    end

    def inner_content
      setup!
      render
    end

    # @group Events

    def change(event)
      setup!

      unless @user.nil? || !@user.admin?
        ls = LootStatus.find(event[:loot_status_id])
        # update the edited metadata with the new value
        ls.update_attribute(event[:loot_status_metadata].to_sym, event[:value])
        # update the score
        ls.compute :score
        # status is to be computed on client-side as a result of dynamic filtering,
        # there's nothing left to do
      end

      render :view => :inner_content
    end

    def plusOne(event)
      setup!

      event['ids'].map(&:to_i).each do |ls_id|
        ls = LootStatus.find(ls_id.to_i)
        ls.increment event['loot_status_metadata']
        ls.compute :score
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
      super
      @loot_machine = LootMachine.find options[:loot_machine_id]
    end
  end

  class AdminConsoleWidget < ConsoleWidget
  end
end
