module SessionsHelper

  def log_in(user)
    # session method defined by Rails, treat it like a hash
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # retrieve the user if a temp session exists, otherwise retrieve the cookie and login the user
  def current_user
    if (user_id = session[:user_id])
      # #find_by returns nil, whereas #find throws an exception, if user not found
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  # a user is logged if there is a current user in the session
  def logged_in?
    !current_user.nil?
  end

  # generate a persistent session
  def remember(user)
    # generate token and save to dbase
    user.remember
    # save the encrypted user_id to a cookie
    cookies.permanent.signed[:user_id] = user.id
    # save the token, with a 20 yr expiry, to the token
    cookies.permanent[:remember_token] = user.remember_token
  end
  # def sign_in(user)
  #   remember_token = User.new_remember_token # create new token
  #   # update browser cookie, sets expiration 20 yrs from now
  #   cookies.permanent[:remember_token] = remember_token
  #   # update the user instance
  #   # once set you can find user with `User.find_by(remember_token: remember_token)`
  #   user.update_attribute(:remember_token, User.digest(remember_token))
  #   # using self ensures that current_user is an instance variable and not a local variable
  #   self.current_user = user
  # end
  #
  # def current_user=(user)
  #   # store the user for latter use
  #   @current_user = user
  # end
  #
  # def current_user
  #   remember_token = User.digest(cookies[:remember_token])
  #   @current_user ||= User.find_by(remember_token: remember_token)
  # end
end
