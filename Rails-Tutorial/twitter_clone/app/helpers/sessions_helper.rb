module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def sign_in(user)
    remember_token = User.new_remember_token # create new token
    # update browser cookie, sets expiration 20 yrs from now
    cookies.permanent[:remember_token] = remember_token
    # update the user instance
    # once set you can find user with `User.find_by(remember_token: remember_token)`
    user.update_attribute(:remember_token, User.digest(remember_token))
    # using self ensures that current_user is an instance variable and not a local variable
    self.current_user = user
  end

  def current_user=(user)
    # store the user for latter use
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
end
