require 'rails_helper'

RSpec.describe "merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 10)

    get "/api/v1/merchants"
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "sends a specific merchant based of id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"
    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

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