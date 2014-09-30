class SessionsController < ApplicationController
  #TODO: Xavier : You have to translate all this, go go go :)
  def new
  end

  def create
    user = User.find_by_email(params[:username])
    user = User.find_by_username(params[:username]) unless user
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      flash.now.alert = 'Email or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
