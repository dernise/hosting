require 'paypal-sdk-rest'
include PayPal::SDK::REST

class OrdersController < ApplicationController
  before_action { PayPal::SDK::Core::Config.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development') }

  def show
    if (!params[:id] || !User.exists?(params[:id].to_i))
      redirect_to root_url
    else
      @account = User.find(params[:id].to_i)
    end
  end

  def create_payment
    if params[:type] == "paypal"
      if !Pack.exists?(params[:id_pack])
        redirect_to root_url
        return
      end
      
      pack = Pack.find(params[:id_pack])
      create_paypal_payment(pack.price, pack.name)
    end
  end

  private

  def create_paypal_payment(price, name)
    @payment = PayPal::SDK::REST::Payment.new({
                                                  :intent => "sale",
                                                  :payer => {
                                                      :payment_method => "paypal" },
                                                  :redirect_urls => {
                                                      :return_url => "http://localhost:3000",
                                                      :cancel_url => "http://localhost:3000" },
                                                  :transactions => [ {
                                                                         :amount => {
                                                                             :total => price.to_s,
                                                                             :currency => "EUR" },
                                                                         :description => "" } ] } )
    @payment.transactions[0].item_list.items[0] = {
        quantity: "1",
        name: name.to_s,
        price: price.to_s,
        currency: 'EUR'
    }

    if @payment.create
      session[:payment_id] = @payment.id
      redirect_to @payment.links[1].href
    else
      @payment.error
    end
  end

  def execute_paypal_payment
    @payment = PayPal::SDK::REST::Payment.find(session[:payment_id])
    @payment.execute( :payer_id => params[:PayerID] )
  end
end
