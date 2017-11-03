class Listing < ApplicationRecord
  belongs_to :user
  has_many :photos

  validates :listing_type, presence: true
  validates :apartment_type, presence: true
  validates :accommodate, presence: true
  validates :bedroom, presence: true
  validates :bathroom, presence: true
  #validates :price, numericality: {greater_than: 0.0}
end
