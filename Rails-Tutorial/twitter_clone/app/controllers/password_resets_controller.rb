class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    # automatically renders views/password_resets/new.html.erb
  end

  # create reset_token and reset_digest
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
    # automatically renders views/password_resets/edit.html.erb
  end

  # check to ensure the reset_token has not expired is excuted prior to #update action
  def update
    if params[:user][:password].empty?
      # update fails due to empty password & password confrmation
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      # update is successful, login user and clear digest
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      # update fails due to invalid password
      render 'edit'
    end
  end


  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        flash[:danger] = "User acount is inactive or account authentication failed"
        redirect_to root_path
      end
    end

    # check that the reset_token has not expired
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
