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
    debugger
    @user = User.new(user_params)
    if @user.save

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
