class UsersController < ApplicationController
  filter_access_to :all
  def index
    @users=User.all
    @pageTitle="Users"
  end
  def new
    @user=User.new
    @pageTitle="Register new user"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Registration successful."
      redirect_to root_url
    else
      render 'new'
    end 
  end

  def edit
    @user = current_user
    @pageTitle="Edit user profile"
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Successfully updated profile."
      redirect_to root_url
    else
      render 'edit'  
    end  
  end  
end
