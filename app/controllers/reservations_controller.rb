class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

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
      #@reservation.save
      if @reservation.save
        if listing.Request?
          flash[:notice] = "Request sent successfully"
        else
            # @reservation.status = 1
            # @reservation.save
          @reservation.Approved!
          flash[:notice] = "Reservation created successfully"
        end
      else
        flash[:alert] = "Cannot make a reservation"
      end
    end
    redirect_to listing
  end


  def trips
    @trips = current_user.reservations.order(start_date: :asc)
  end

  def my_reservations
    @listings = current_user.listings
  end

  def approve
    @reservation.Approved!
    redirect_to my_reservations_path
  end

  def decline
    @reservation.Declined!
    redirect_to my_reservations_path
  end

  private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
