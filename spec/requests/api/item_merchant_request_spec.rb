require 'rails_helper'

RSpec.describe "Item Merchant API Requests" do

  it 'returns an items merchant' do
    merchant1 = create(:merchant)
    item = create(:item, merchant_id: merchant1.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    result = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(result).to have_key(:id)
    expect(result[:id]).to be_a String
    
    expect(result).to have_key(:type)
    expect(result[:type]).to eq('merchant')

    expect(result[:attributes]).to have_key(:name)
    expect(result[:attributes][:name]).to be_a String
  end

  it 'returns 404 error when the item does not exist' do
    get "/api/v1/items/0/merchant"

    expect(response).to have_http_status(404)
  end
end