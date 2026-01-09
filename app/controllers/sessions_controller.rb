class SessionsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
  end

  def create
    if user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
      start_new_session_for(user)
      redirect_to after_authentication_url, notice: "Welcome back!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "Signed out successfully"
  end
end
