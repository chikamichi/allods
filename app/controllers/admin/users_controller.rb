class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_adminship

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: I18n.t('.admin.user_account_created', email: @user.email) }
        format.json { render :json => @user, :status => :created, :location => root_path }
      else
        render_errors(format, @user.errors)
      end
    end
  end
end
