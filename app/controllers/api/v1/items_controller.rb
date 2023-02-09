class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def update
    if Item.update(params[:id], item_params).save 
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render status: 404
    end
  end

  def destroy
    Item.destroy(params[:id])
  end

  def find_all
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
    else params[:max_price]
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
  
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end