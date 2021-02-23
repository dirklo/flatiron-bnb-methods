class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation_id, presence: true
  validate :accepted
  validate :checkout_complete

  def accepted
    if reservation && reservation.status != "accepted" && reservation.status
      errors.add(:reservation_id, "Reservation must be accepted to write a review")
    end
  end

  def checkout_complete
    if reservation && Date.today < reservation.checkout
      errors.add(:reservation_id, "Checkout date must be in the past to leave a review.")
    end
  end
end
