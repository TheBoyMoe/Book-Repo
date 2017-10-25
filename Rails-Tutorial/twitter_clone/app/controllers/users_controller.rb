class UsersController < ApplicationController
  def new
    # user object passed to the #form_for helper
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    # passing the params[:user] hash to User.new() is a risk, prevented by default in rails
    # @user = User.new(params[:user])

    @user = User.new(user_params)
    if @user.save
      # displayed on the first page after redirect
      flash[:success] = "Welcome to the Sample App!"
      # you can use users_url, users_path or simply @user
      redirect_to user_path(@user)
    else
      render 'new'
    end

  end

  private
    def user_params
      # params must have a 'user' hash, with only the following atttributes
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


end
