class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    available_listings = []
    listings.each do |listing|
      available = true
      listing.reservations.each do |reservation|
        if start_date.to_date.between?(reservation.checkin, reservation.checkout) || end_date.to_date.between?(reservation.checkin, reservation.checkout)
          available = false
        end
      end 
      available_listings << listing if available == true
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    current_highest = 0.0
    highest_neighborhood = Neighborhood.new 
    self.all.each do |neighborhood|
      res = neighborhood.reservations.count
      list = neighborhood.listings.count
      if res != 0 && list != 0
        ratio = res.to_f/list.to_f
      else 
        ratio = 0
      end 
      if ratio > current_highest
        current_highest = ratio
        highest_neighborhood = neighborhood
      end
    end
    highest_neighborhood
  end

  def self.most_res
    current_highest = 0
    highest_neighborhood = Neighborhood.new 
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > current_highest
        current_highest = neighborhood.reservations.count
        highest_neighborhood = neighborhood
      end
    end
    highest_neighborhood
  end
end


