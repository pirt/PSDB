class UserSessionsController < ApplicationController
  def new
    @user_session=UserSession.new
    @pageTitle="Login"
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Successfully logged in."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:success] = "Successfully logged out."
    redirect_to root_url
  end  
end
