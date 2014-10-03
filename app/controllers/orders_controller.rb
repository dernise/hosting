require 'paypal-sdk-rest'
include PayPal::SDK::REST

class OrdersController < ApplicationController
  before_action { PayPal::SDK::Core::Config.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development') }

  def show
    if (!params[:id] || !User.exists?(params[:id].to_i))
      redirect_to root_url
    else
      @account = User.find(params[:id].to_i)
      session[:id_to_credit] = params[:id]
    end
  end

  def create_payment
    if !Pack.exists?(params[:id_pack])
      redirect_to root_url
      return
    end

    pack = Pack.find(params[:id_pack])

    if params[:type] == "paypal"
      create_paypal_payment(pack.price, pack.name)
    end

    if params[:type] == "allopass"

    end
  end

  def execute_payment
    execute_paypal_payment
  end

  private

  def create_paypal_payment(price, name)
    @payment = PayPal::SDK::REST::Payment.new({
                                                  :intent => "sale",
                                                  :payer => {
                                                      :payment_method => "paypal" },
                                                  :redirect_urls => {
                                                      :return_url => "#{root_url}/order/execute_payment/",
                                                      :cancel_url => root_url.to_s },
                                                  :transactions => [ {
                                                                         :amount => {
                                                                             :total => price.to_s,
                                                                             :currency => "EUR" },
                                                                         :description => "" } ] } )
    @payment.transactions[0].item_list.items[0] = {
        quantity: "1",
        name: name.to_s,
        price: price.to_s,
        currency: 'EUR',
    }

    if @payment.create
      session[:payment_paypal_id] = @payment.id
      redirect_to @payment.links[1].href
      return
    else
      @payment.error
    end
  end

  def execute_paypal_payment
    @payment = PayPal::SDK::REST::Payment.find(session[:payment_paypal_id])
    @payment.execute( :payer_id => params[:PayerID] )
  end
end
