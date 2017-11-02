class ListingsController < ApplicationController
  before_action :set_listing, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]

  def index
    @listings = current_user.listings
  end

  def new
    @listing = current_user.listings.build
  end

  def create
    @listing = current_user.listings.build(listing_params)
    if @listing.save
      redirect_to listing_listing_path(@listing), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end

  def show
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
  end

  def amenities
  end

  def location
  end

  def update
    if @listing.update(listing_params)
      flash[:notice] = "saved..."
    else
      flash[:notice] = "Something went wrong"
    end
      redirect_back(fallback_location: request.referer)
  end

  private
    def set_listing
      @listing = Listing.find(params[:id])
    end

    def listing_params
      params.require(:listing).permit(:listing_type, :apartment_type, :accommodate,
                                      :bedroom, :bathroom, :listing_name, :summary,
                                      :address, :tv, :kitchen, :air, :heating, :internet,
                                      :price, :active)
    end
end
