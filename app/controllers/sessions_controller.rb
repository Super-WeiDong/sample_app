class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # authenticate method provided by has_secure_password
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      log_in user
      redirect_to forwarding_url || user
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
