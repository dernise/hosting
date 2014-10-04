require 'paypal-sdk-rest'
include PayPal::SDK::REST

class OrdersController < ApplicationController
  before_action { PayPal::SDK::Core::Config.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development') }

  def show
    if (!params[:id] || !User.exists?(params[:id].to_i))
      redirect_to root_url
      return
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
    if params[:type] == "paypal"
      execute_paypal_payment
    end
  end

  private

  def create_paypal_payment(price, name)
    @payment = PayPal::SDK::REST::Payment.new({
                                                  :intent => "sale",
                                                  :payer => {
                                                      :payment_method => "paypal" },
                                                  :redirect_urls => {
                                                      :return_url => "#{root_url}/order/execute_payment/paypal/",
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
    if(session.has_key?(:payment_paypal_id) && session.has_key?(:id_to_credit))
      @payment = PayPal::SDK::REST::Payment.find(session[:payment_paypal_id])
      if(@payment.execute( :payer_id => params[:PayerID] ))
        token_quantity = Pack.find_by_name(@payment.transactions[0].item_list.items[0].name.to_s).quantity

        user = User.find(session[:id_to_credit].to_i)
        user.tokens += token_quantity
        user.save

        @validation = "Successfuly added #{token_quantity} tokens to the account #{user.username}!" #TODO: Xavier :P
      else
        @validation = "Could not add the tokens to the account. Don't worry, we didn't get any money from you." #TODO: Xavier :P
      end
    else
      @payment.destroy
      @validation = "You took too much time to complete your order. Please retry. Don't worry, we didn't get any money from you." #TODO: Xavier :P
    end
  end
end
