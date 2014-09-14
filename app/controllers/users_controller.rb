class UsersController < ApplicationController
  #before_action :check_login
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @users = User.all.to_a

  end

  def new
    @user = User.new
  end

  def edit

  end

  # Users are created in a multi model form in instructors so we have
  # user params and so we get params from the user from the instructor form
  # and use it to make the user rest of the actions are standard restful actions
  def create
    @user = User.new(user_params)
    @user.save!
    if @user.save
      session[:user_id] = @user.id
      redirect_to(home_path)
    else
      render :action => "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end

  end

  private
  def user_params
    params.require(:user).permit(:username, :id, :instructor_id,:active,:role,:password,:password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
