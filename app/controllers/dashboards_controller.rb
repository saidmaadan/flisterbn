class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @listings = current_user.listings
  end
end
