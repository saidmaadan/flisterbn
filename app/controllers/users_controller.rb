class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @listings = @user.listings
    redirect_to root_path, notice: "You don't have permission to see this profile" unless current_user == @user
  end
end
