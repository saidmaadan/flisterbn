class PagesController < ApplicationController
  def home
    @listings = Listing.where(active: true).limit(4)
  end
end
