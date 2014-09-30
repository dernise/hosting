class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title
      t.boolean :resolved
      t.integer :user_id

      t.timestamps
    end
  end
end
