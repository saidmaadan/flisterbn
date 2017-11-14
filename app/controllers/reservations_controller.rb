class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

  def create
    listing = Listing.friendly.find(params[:listing_id])

    if current_user == listing.user
      flash[:alert] = "You cannot book your own property!"
    elsif current_user.stripe_id.blank?
      flash[:alert] = "Please update your payment method"
      return redirect_to payment_method_path
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.listing = listing
      @reservation.price = listing.price
      @reservation.total = listing.price * days

      if @reservation.Waiting!
        if listing.Request?
          flash[:notice] = "Request sent successfully"
        else
          charge(listing, @reservation)
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
    charge(@reservation.listing, @reservation)
    redirect_to my_reservations_path
  end

  def decline
    @reservation.Declined!
    redirect_to my_reservations_path
  end

  private

    def charge(listing, reservation)
      if !reservation.user.stripe_id.blank?
        customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
        charge = Stripe::Charge.create(
          :customer => customer.id,
          :amount => reservation.total * 100,
          :description => listing.listing_name,
          :currency => "usd",
          :destination => {
            :amount => reservation.total * 90, #90% of the total amount goes to the Host
            :account => listing.user.merchant_id #Host's Stripe customer ID
          }
        )

        if charge
          reservation.Approved!
          flash[:notice] = "Reservation created successfully!"
        else
          reservation.declined!
          flash[:alert] = "Cannot charge with this payment method"
        end
      end
    rescue Stripe::CardError => e
      reservation.declined!
      flash[:alert] = e.message
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
