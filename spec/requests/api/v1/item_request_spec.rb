require 'rails_helper'

RSpec.describe "Items API" do
  before(:each) do
    @merchant1 = create(:merchant)
  end

  it "sends a list of items" do
    create_list(:item, 10, merchant_id: @merchant1.id)

    get "/api/v1/items"
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "sends a specific item based of id" do
    id = create(:item, merchant_id: @merchant1.id).id

    get "/api/v1/items/#{id}"
    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
  end

  it 'can create a new item' do
    item_params = {
      "name": "Shiny Itemy Item",
      "description": "It does a lot of things real good.",
      "unit_price": 123.45,
      "merchant_id": @merchant1.id
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last
    expect(response).to be_successful
    expect(created_item.name).to eq('Shiny Itemy Item')
    expect(created_item.description).to eq('It does a lot of things real good.')
    expect(created_item.unit_price).to eq(123.45)
    expect(created_item.merchant_id).to eq(@merchant1.id)
  end

  it 'can update an item' do
    item = create(:item, merchant_id: @merchant1.id)
    original_name = Item.last.name
    item_params = { "name": "Pokemon Cards" }
  
    headers = { "CONTENT_TYPE" => "application/json" }
      
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
  
    item = Item.find(item.id)
    expect(response).to be_successful
    expect(item.name).to_not eq(original_name)
    expect(item.name).to eq("Pokemon Cards")
  end

  it 'can destroy an item' do
    item = create(:item, merchant_id: @merchant1.id)
    
    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
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

  it 'returns an error if no items found' do
    item1 = create(:item, name: 'Ball', merchant_id: @merchant1.id)
    item2 = create(:item, name: 'Item Repellendus Harum', merchant_id: @merchant1.id)
    item3 = create(:item, name: 'Item Harum Molestiae', merchant_id: @merchant1.id)
    item4 = create(:item, name: 'Item Explicabo Harum', merchant_id: @merchant1.id)

    get '/api/v1/items/find_all?name=PHONE'

    result = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(result).to eq []
  end
end