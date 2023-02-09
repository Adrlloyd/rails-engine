class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    if params[:name]
      search = params[:name]
      merchant = Merchant.find_one(search)
      if merchant.nil?
        render json: { data: {error: "No merchant found"} }
      else 
        render json: MerchantSerializer.new(merchant)
      end 
    end 
  end
end