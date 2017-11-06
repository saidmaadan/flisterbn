class HostReviewsController < ApplicationController

  def create
    @host_review = current_user.host_reviews.create(host_review_params)
    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @host_review = Review.find(params[:id])
    @host_review.destroy
    redirect_back(fallback_location: request.referer, notice: "Review has been removed...")
  end

  private
    def host_review_params
      params.require(:host_review).permit(:comment, :star, :listing_id, :reservation_id, :guest_id)
end
