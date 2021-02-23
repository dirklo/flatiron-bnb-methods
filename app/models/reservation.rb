class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing
  validates :checkin, :checkout, presence: true
  validate :not_own_listing
  validate :is_available
  validate :checkin_before_checkout

  def not_own_listing
    if listing.host == guest
      errors.add(:host_id, "Cannot be the guest on your own listing")
    end
  end

  def is_available
    if checkin && checkout
      bookings = listing.reservations.map{|r| [r.checkin, r.checkout] }
      available = true
      bookings.each do |b|
        available = false if checkin.between?(b[0], b[1])
        available = false if checkout.between?(b[0], b[1])
      end 
      if available == false
        errors.add(:checkin, "Listing Not Available on Those Dates")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if checkin >= checkout
        errors.add(:checkin, "Checkin Date Must Be Before Checkout Date")
      end
    end
  end

  def duration 
    checkout - checkin
  end

  def total_price
    listing.price.to_i * duration.to_i
  end
end
