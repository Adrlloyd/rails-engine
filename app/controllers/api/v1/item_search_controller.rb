class Api::V1::ItemSearchController < ApplicationController
  
  def index #find_all
    if  (params[:min_price] || params[:max_price]) && params[:name]
      render status: 400
    elsif params[:name]
      search = params[:name]
      found = Item.find_all(search)
      if search.nil?
        render json: { data: {errors: "No item found"} }, status: 400
      else 
        render json: ItemSerializer.new(found)
      end
    elsif params[:min_price]
      min_below_zero
    elsif params[:max_price]
      max_below_zero
    end
  end
    
  def min_below_zero
    price = params[:min_price].to_f
    found = Item.min_price(price)
    if price <= 0
      render json: { errors: 'price cant be zero'},  status: 400
    else
      render json: ItemSerializer.new(found)
    end
  end

  def max_below_zero
    price = params[:min_price].to_f
    found = Item.max_price(price)
    if price <= 0
      render json: { errors: 'price cant be zero'},  status: 400
    else
      render json: ItemSerializer.new(found)
    end
  end
end