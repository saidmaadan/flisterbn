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
    if !current_user.active_host
      return redirect_to payout_method_path, alert: "Please Connect to Stripe Express..."
    end

    @listing = current_user.listings.build(listing_params)
    if @listing.save
      redirect_to listing_listing_path(@listing), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end

  def show
    @photos = @listing.photos
    @guest_reviews = @listing.guest_reviews
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

  def preload
    today = Date.today
    reservations = @listing.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)

    render json: reservations
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: date_conflict(start_date, end_date, @listing)
    }

    render json: output
  end


  private
    def date_conflict(start_date, end_date, listing)
      check = listing.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
      check.size > 0? true : false
    end

    def set_listing
      @listing = Listing.friendly.find(params[:id])
    end

    def is_authorized
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @listing.user_id
    end

    def listing_is_ready
      !@listing.active && !@listing.price.blank? && !@listing.listing_name.blank? && !@listing.photos.blank? && !@listing.address.blank?
    end

    def listing_params
      params.require(:listing).permit(:listing_type, :apartment_type, :accommodate, :bedroom, :bathroom, :listing_name, :summary,:address, :tv, :kitchen, :air, :heating, :internet, :price, :active, :instant)
    end
end
