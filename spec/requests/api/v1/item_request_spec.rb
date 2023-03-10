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

  it 'retuns an error if any attributes are missing' do
    item_params = {
      "name": "Shiny Itemy Item",
      "description": "It does a lot of things real good.",
      "merchant_id": @merchant1.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      
    expect(response.status).to eq(404)
  end 
  
  it 'ignores any attributes sent that are not allowed' do 
    item_params = {
      "name": "Shiny Itemy Item",
      "description": "It does a lot of things real good.",
      "unit_price": 123.45,
      "is_this_relevent": 'No',
      "merchant_id": @merchant1.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    
    result = JSON.parse(response.body, symbolize_names: true)
    
    expect(result[:data][:attributes]).to_not have_key(:is_this_relevent)
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

  it 'bad merchant id wont allow item update' do
    original_item = create(:item, merchant_id: @merchant1.id)
    updated_params = { "merchant_id": 90814097189273 }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{original_item.id}", headers: headers, params: JSON.generate(item: updated_params)
    
    expect(response.status).to eq(404)
  end 

  it 'can destroy an item' do
    item = create(:item, merchant_id: @merchant1.id)
    
    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
  end
end