class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]
  def show
    @listings = @user.listings

    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)

    @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)
    #redirect_to root_path, notice: "You don't have permission to see this profile" unless current_user == @user
  end

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
