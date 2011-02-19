class CharactersController < ApplicationController
  include Apotomo::Rails::ControllerMethods

  has_widgets do |root|
    @character.loot_statuses.each do |ls|
      root << widget('loot_stats', "loot_stats-#{ls.id}", :ls => ls)
    end
  end

  before_filter :authenticate_user!, :except => [:index, :show]

  # @get
  #
  def index
    if user_signed_in?
      @own_characters = Character.for current_user
      @characters = Character.for_everyone_but current_user
    else
      @characters = Character.all
    end
  end

  # @get
  #
  def new
    @character = Character.new
  end

  # @post
  #
  def create
    @character = Character.new(params[:character])
    @character.user = current_user

    respond_to do |format|
      if @character.save
        format.html { redirect_to character_url(@character.reload), :notice => :created! }
        format.json { render :json => @character, :status => :created, :location => character_url(@character) }
      else
        render_errors(format, @character.errors)
      end
    end
  end

  # @get
  #
  def show
    @character = Character.find(params[:id])
    title! :nickname => @character.nickname

    respond_to do |format|
      format.html
      format.json { render :json => @character }
    end
  end

  # @get
  #
  def edit
    @character = Character.find(params[:id])
    title! :nickname => @character.nickname
  end

  # @put
  #
  def update
    @character = Character.find(params[:id])

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to character_url(@character), :notice => updated! }
        format.json { rende  :json => @character, :status => :ok }
      else
        render_errors(format, @character.errors)
      end
    end
  end
end
