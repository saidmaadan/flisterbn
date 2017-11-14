class Reservation < ApplicationRecord
  enum status: { Waiting: 0, Approved: 1, Declined: 2 }

  belongs_to :user
  belongs_to :listing

  scope :current_week_revenue, -> (user){
    joins(:listing)
    .where("listings.user_id = ? AND reservations.updated_at >= ? AND reservations.status = ?", user.id, 1.week.ago, 1)
    .order(updated_at: :asc)
  }
end
