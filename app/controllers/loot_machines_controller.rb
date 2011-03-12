class LootMachinesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :require_adminship,  :except => [:index, :show]

  has_widgets do |root|
    if current_loot_machine
      root << widget('loot_machine_widgets/console',
                     "loot_machine_console_#{current_loot_machine.id}",
                     :loot_machine_id => current_loot_machine.id,
                     :user => current_user)
    end
  end

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
    @loot_machine = LootMachine.new(params[:loot_machine])

    respond_to do |format|
      if @loot_machine.save
        format.html { redirect_to loot_machines_url, :notice => :created! }
        format.json { render :json => @loot_machine, :status => :created, :location => loot_machine_url(@loot_machine) }
      else
        render_errors(format, @loot_machine.errors)
      end
    end
  end

  # @get
  #
  def show
    @loot_machine = current_loot_machine 

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
    @loot_machine = current_loot_machine 
    @characters   = Character.all
  end

  # @put
  #
  def update
    @loot_machine = current_loot_machine

    respond_to do |format|
      if @loot_machine.update_attributes(params[:loot_machine])
        format.html { redirect_to loot_machine_url(@loot_machine), :notice => updated! }
        format.json { rende  :json => @loot_machine, :status => :ok }
      else
        render_errors(format, @loot_machine.errors)
      end
    end
  end

  private

  def current_loot_machine
    @loot_machine = LootMachine.find(params[:loot_machine_id] || params[:id])
  end
end
