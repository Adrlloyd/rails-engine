require 'rails_helper'

RSpec.describe "Search/Find all Items API" do
  before(:each) do
    @merchant1 = create(:merchant)
  end

  it 'returns items that matches a search term' do
    item1 = create(:item, name: 'Ball', merchant_id: @merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', merchant_id: @merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', merchant_id: @merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', merchant_id: @merchant1.id)

    get '/api/v1/items/find_all?name=hArU'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer
    end
  end

  it 'returns an error if min or max & name is used to search' do  
    item1 = create(:item, name: 'Ball', unit_price: 2.50, merchant_id: @merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', unit_price: 4.50, merchant_id: @merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', unit_price: 1.50, merchant_id: @merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', unit_price: 10.50, merchant_id: @merchant1.id)

    get '/api/v1/items/find_all?name=ring&min_price=50&max_price=250'

    expect(response.status).to eq(400)
  end

  it 'wont allow min price to be equal or below zero' do  
    item1 = create(:item, name: 'Ball', unit_price: 2.50, merchant_id: @merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', unit_price: 4.50, merchant_id: @merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', unit_price: 1.50, merchant_id: @merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', unit_price: 10.50, merchant_id: @merchant1.id)

    get '/api/v1/items/find_all?min_price=0.00'

    
    expect(response.status).to eq(400)
  end

  it 'wont allow max price to be equal or below zero' do  
    item1 = create(:item, name: 'Ball', unit_price: 2.50, merchant_id: @merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', unit_price: 4.50, merchant_id: @merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', unit_price: 1.50, merchant_id: @merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', unit_price: 10.50, merchant_id: @merchant1.id)

    get '/api/v1/items/find_all?max_price=0.00'

    expect(response.status).to eq(400)
  end

  it 'returns items that are equal or above input value' do
    merchant1 = create(:merchant)    
    item1 = create(:item, name: 'Ball', unit_price: 2.50, merchant_id: merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', unit_price: 1.50, merchant_id: merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', unit_price: 10.50, merchant_id: merchant1.id)
   
    get '/api/v1/items/find_all?min_price=10.00'

    expect(Item.min_price(10.00)).to eq([item4])
  end

  it 'returns items that are equal or below input value' do
    merchant1 = create(:merchant)    
    item1 = create(:item, name: 'Ball', unit_price: 2.50, merchant_id: merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', unit_price: 1.50, merchant_id: merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', unit_price: 10.50, merchant_id: merchant1.id)
   
    get '/api/v1/items/find_all?max_price=5.00'

    expect(Item.max_price(5.00)).to eq([item1, item2, item3])
  end 
end
