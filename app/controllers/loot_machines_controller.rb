class LootMachinesController < ApplicationController
  include Apotomo::Rails::ControllerMethods

  has_widgets do |root|
    if current_loot_machine
      # @see http://rubydoc.info/github/apotonick/apotomo/master/Apotomo/WidgetShortcuts:widget
      root << widget('loot_machine_widgets/console',
                    "loot_machine_console_#{current_loot_machine.id}",
                    :loot_machine_id => current_loot_machine.id)
    end
  end

  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :require_adminship,  :except => [:index, :show]

  # @get
  #
  def index
    @loot_machines = LootMachine.all
  end

  # @get
  #
  def new
    @loot_machine = LootMachine.new
    @characters   = Character.all
  end

  # @post
  #
  def create
    @lm = LootMachine.new(params[:loot_machine])

    respond_to do |format|
      if @lm.save
        format.html { redirect_to loot_machines_url, :notice => :created! }
        format.json { render :json => @lm, :status => :created, :location => loot_machine_url(@lm) }
      else
        render_errors(format, @lm.errors)
      end
    end
  end

  # @get
  #
  def show
    @loot_machine = LootMachine.find(params[:id])
    title! :group_title => @loot_machine.title
    hint!  :count       => @loot_machine.characters.count

    respond_to do |format|
      format.html
      format.json { render :json => @loot_machine }
    end
  end

  # @get
  #
  def edit
    @loot_machine = LootMachine.find(params[:id])
    @characters   = Character.all
  end

  # @put
  #
  def update
    @lm = LootMachine.find(params[:id])

    respond_to do |format|
      if @lm.update_attributes(params[:loot_machine])
        format.html { redirect_to loot_machine_url(@lm), :notice => updated! }
        format.json { rende  :json => @lm, :status => :ok }
      else
        render_errors(format, @lm.errors)
      end
    end
  end

  private

  def current_loot_machine
    @loot_machine = LootMachine.find(params[:loot_machine_id] || params[:id])
  end
end
