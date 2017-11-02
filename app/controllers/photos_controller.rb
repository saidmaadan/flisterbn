class PhotosController < ApplicationController

  def create
    @listing = Listing.find(params[:listing_id])
    if params[:images]
      params[:images].each do |img|
        @listing.photos.create(image: img)
      end

      @photos = @listing.photos
      redirect_back(fallback_location: request_referer, notice: "Save...")
    end
  end
end
