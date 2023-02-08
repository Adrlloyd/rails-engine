class Api::V1::ItemMerchantController < ApplicationController

  def index
    item_id = params[:item_id]
    if Item.exists?(item_id)
      item = Item.find(item_id)
      render json: MerchantSerializer.new(item.merchant)
    else
      render status: 404
    end 
  end
end 