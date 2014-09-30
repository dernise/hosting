class OrdersController < ApplicationController
  def show
    @cart = current_cart
    @url = "http://localhost:3000/users/show/
  end
end
