class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :ticket_id

      t.timestamps
    end
  end
end
