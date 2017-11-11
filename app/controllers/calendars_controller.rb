class CalendarsController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def host
    @listings = current_user.listings

    params[:start_date] ||= Date.current.to_s
    params[:listing_id] ||= @listings[0] ? @listings[0].id : nil

    if params[:q].present?
      params[:start_date] = params[:q][:start_date]
      params[:listing_id] = params[:q][:listing_id]
    end

    @search = Reservation.ransack(params[:q])

    if params[:listing_id]
      @listing = Listing.friendly.find(params[:listing_id])
      start_date = Date.parse(params[:start_date])

      first_of_month = (start_date - 1.months).beginning_of_month
      end_of_month = (start_date + 1.months).end_of_month

      @events = @listing.reservations.joins(:user)
                        .select('reservations.*, users.first_name, users.last_name, users.image, users.email, users.uid')
                        .where('(start_date BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)
      @events.each{ |e| e.image = avatar_url(e) }

    else
      @listing = nil
      @events = []
    end
  end
end
