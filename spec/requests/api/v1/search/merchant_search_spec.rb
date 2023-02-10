require 'rails_helper'

RSpec.describe "Search/Find one Merchant API" do
  it 'returns a merchant from a search' do
    create_list(:merchant, 2)
    create(:merchant, name: "Boxxx")

    get "/api/v1/merchants/find?name=xxx"
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(1)

    expect(merchants[:data][:attributes]).to have_key(:name)
    expect(merchants[:data][:attributes][:name]).to eq("Boxxx")
  end

  it 'returns an error if no merchant found' do
    create_list(:merchant, 2)
    
    get "/api/v1/merchants/find?name=xxxxx"
    result = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(result[:error]).to eq("No merchant found")
  end
end