class ListingsController < ApplicationController
  before_action :set_listing, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: [:listing, :pricing, :description, :amenities, :photo_upload, :location, :update]

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
    @photos = @listing.photos
  end

  def amenities
  end

  def location
  end

  def update
    new_params = listing_params
    new_params = listing_params.merge(active: true) if listing_is_ready
    if @listing.update(new_params)
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

    def is_authorized
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @listing.user_id
    end

    def listing_is_ready
      !@listing.active && !@listing.price.blank? && !@listing.listing_name.blank? && !@listing.photos.blank? && !@listing.address.blank?
    end

    def listing_params
      params.require(:listing).permit(:listing_type, :apartment_type, :accommodate,
                                      :bedroom, :bathroom, :listing_name, :summary,
                                      :address, :tv, :kitchen, :air, :heating, :internet,
                                      :price, :active)
    end
end
