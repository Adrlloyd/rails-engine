class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  
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

  def delete_invoice
    invoices.each do |invoice| 
      invoice.destroy if invoice.items.count==1
    end
  end
end
