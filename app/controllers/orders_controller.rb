class OrdersController < ApplicationController
  def show
    @cart = current_cart
    if (!params[:id] || !User.exists?(params[:id].to_i))
      redirect_to root_url
    else
      @account = User.find(params[:id].to_i)
      @url = root_url+"/order/validate/"+params[:id]
    end
  end

  def validate

  end
end
