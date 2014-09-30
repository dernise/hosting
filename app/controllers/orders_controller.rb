class OrdersController < ApplicationController
  def show
    @cart = current_cart
    if (!params[:id] || !User.exists?(params[:id].to_i))
      redirect_to root_url
    else
      @account = User.find(params[:id].to_i)
    end

    #@url = root_url+"/users/validate_order/"+params[:id]+"/"
  end
end
