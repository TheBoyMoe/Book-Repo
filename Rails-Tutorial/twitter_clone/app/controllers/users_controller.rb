class UsersController < ApplicationController

  # `before filter` - ensure that users are logged in before they can
  # execute the following actions, by default before_filter applies to every action
  before_action :logged_in_user, only: [:index, :edit, :update]

  # ensure that the current user can only edit/update their own profile
  before_action :correct_user, only: [:edit, :update]


  def index
    
  end

  def new
    # renders the #form_for helper
    @user = User.new
  end

  def show
    # renders the user profile
    @user = User.find(params[:id])
  end

  def create
    # passing the params[:user] hash to User.new() is a risk, prevented by default in rails
    # @user = User.new(params[:user])

    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      # displayed on the first page after redirect
      flash[:success] = "Welcome to the Sample App!"
      # you can use users_url, users_path or simply @user
      redirect_to user_path(@user)
    else
      render 'new'
    end

  end

  def edit
    # find the user in the database, render the user profile for editing
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy

  end

  private
    def user_params
      # params must have a 'user' hash, with only the following atttributes
      # to is to prevent mass assignment vulnerability
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Please log in'
        redirect_to login_url
      end
    end

    def correct_user
      user = User.find_by(id: params[:id])
      if !current_user?(user)
        flash[:danger] = 'You are not authorised to view that page'
        redirect_to root_path
        return false
      end
      return true
    end

end
