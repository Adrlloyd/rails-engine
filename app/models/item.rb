class Item < ApplicationRecord
  belongs_to :merchant
  
  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price

  def self.find_all(search)
    Item.where("name ILIKE ?", "%#{search}%")
  end

  def self.min_price(price)
    Item.where("unit_price >= ?", price)
  end

  def self.max_price(price)
    Item.where("unit_price <= ?", price)
  end
end
