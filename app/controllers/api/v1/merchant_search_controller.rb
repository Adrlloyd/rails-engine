class Api::V1::MerchantSearchController < ApplicationController
  def show #find
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