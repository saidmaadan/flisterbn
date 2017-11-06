class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def create
    listing = Listing.friendly.find(params[:listing_id])

    if current_user == listing.user
      flash[:alert] = "You cannot book your own property!"
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.listing = listing
      @reservation.price = listing.price
      @reservation.total = listing.price * days
      @reservation.save

      flash[:notice] = "Booked Successfully!"
    end
    redirect_to listing
  end

  def trips
    @trips = current_user.reservations.order(start_date: :asc)
  end

  def your_reservations
    @listings = current_user.listings
  end

  private
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
