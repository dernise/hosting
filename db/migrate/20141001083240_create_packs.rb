class CreatePacks < ActiveRecord::Migration
  def change
    create_table :packs do |t|
      t.string :name
      t.integer :quantity
      t.integer :price

      t.timestamps
    end
  end
end
