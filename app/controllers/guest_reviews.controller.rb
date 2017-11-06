class GuestReviewsController < ApplicationController

  def create
    @reservation = Reservation.where(
                    id: guest_review_params[:reservation_id],
                    listing_id: guest_review_params[:listing_id],
                    ).first

    if !@reservation.nil? && @reservation.listing.user.id == guest_review_params[:host_id].to_i
      @has_reviewed = GuestReview.where(
                        reservation_id: @reservation.id,
                        guest_id: guest_review_params[:guest_id]
      ).first

      if @has_reviewed.nil?
        @guest_review = current_user.guest_reviews.create(guest_review_params)
        flash[:success] = "Reviewed created successfully..."
      else
        flash[:success] = "You already reviewed this reservation..."
      end
    else
      flash[:alert] = "Not found this reservation"
    end
    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @guest_review = Review.find(params[:id])
    @guest_review.destroy
    redirect_back(fallback_location: request.referer, notice: "Review has been removed...")
  end

  private
    def guest_review_params
      params.require(:guest_review).permit(:comment, :star, :listing_id, :reservation_id, :guest_id)
end
