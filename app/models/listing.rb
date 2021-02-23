class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  before_save :change_user_host_status
  after_destroy :check_user_host_status

  def change_user_host_status
    host.host = true
    host.save
  end

  def check_user_host_status
    if host.listings.empty?
      host.host = false
      host.save
    end
  end

  def average_review_rating
    total = 0
    reviews.each do |review|
      total += review.rating
    end
    total.to_f/reviews.count.to_f
  end
end
