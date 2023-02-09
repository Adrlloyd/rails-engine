require 'rails_helper'

RSpec.describe Item, type: :model do 

  describe 'validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price) }
  end 

  describe 'relationships' do
    it { should belong_to :merchant }
  end

  it 'returns items that matches a search term' do
    merchant1 = create(:merchant)    
    item1 = create(:item, name: 'Ball', merchant_id: merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', merchant_id: merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', merchant_id: merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', merchant_id: merchant1.id)
   
    expect(Item.find_all('hArU')).to eq([item2, item3, item4])
  end

  it 'returns items that are equal or above input value' do
    merchant1 = create(:merchant)    
    item1 = create(:item, name: 'Ball', unit_price: 2.50, merchant_id: merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', unit_price: 1.50, merchant_id: merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', unit_price: 10.50, merchant_id: merchant1.id)
   
    expect(Item.min_price(3.00)).to eq([item2, item4])
  end

  it 'returns items that are equal or below input value' do
    merchant1 = create(:merchant)    
    item1 = create(:item, name: 'Ball', unit_price: 2.50, merchant_id: merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', unit_price: 1.50, merchant_id: merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', unit_price: 10.50, merchant_id: merchant1.id)
   
    expect(Item.max_price(3.00)).to eq([item1, item3])
  end 
end