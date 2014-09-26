class AddTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tokens, :integer
  end
end
