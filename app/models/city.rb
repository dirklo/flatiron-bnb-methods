class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
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
    highest_city = City.new 
    self.all.each do |city|
      ratio = (city.reservations.count/city.listings.count).to_f
      if ratio > current_highest
        current_highest = ratio
        highest_city = city
      end
    end
    highest_city
  end

  def self.most_res
    current_highest = 0
    highest_city = City.new 
    self.all.each do |city|
      if city.reservations.count > current_highest
        current_highest = city.reservations.count
        highest_city = city
      end
    end
    highest_city
  end
end

