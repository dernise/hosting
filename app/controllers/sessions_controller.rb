class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:username])
    user = User.find_by_username(params[:username]) unless user
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: t('login.loggedin')
    else
      flash.now.alert = t('login.invalid')
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: t('login.loggedout')
  end
end
