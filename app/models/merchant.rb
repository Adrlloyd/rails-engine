class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name

  def self.find_one(search) 
    Merchant.where("name ILIKE ?", "%#{search}%").order(:name).first
  end 
end