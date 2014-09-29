class Cart < ActiveRecord::Base
  def paypal_url(return_url, amount, name_item)

    values = {
        :business => 'admin.orcade@gmail.com',
        :cmd => '_cart',
        :upload => 1,
        :return => return_url,
        :invoice => id
    }
    values.merge!({
                      "amount_1" => amount,
                      "item_name_1" => name_item,
                      "item_number_1" => 1,
                      "quantity_1" => 1
                  })

    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query

  end
end
