require 'rails_helper'

RSpec.describe ListingController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #listing" do
    it "returns http success" do
      get :listing
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #pricing" do
    it "returns http success" do
      get :pricing
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #description" do
    it "returns http success" do
      get :description
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #photo_upload" do
    it "returns http success" do
      get :photo_upload
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #amenities" do
    it "returns http success" do
      get :amenities
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #location" do
    it "returns http success" do
      get :location
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      get :update
      expect(response).to have_http_status(:success)
    end
  end

end
