class Listing < ApplicationRecord
  belongs_to :user

  validates :listing_type, presence: true
  validates :apartment_type, presence: true
  validates :accommodate, presence: true
  validates :bedroom, presence: true
  validates :bathroom, presence: true
end
