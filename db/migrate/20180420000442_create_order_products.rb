class CreateOrderProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :order_products do |t|
      t.integer :quantity
      t.string :status

      t.timestamps
    end
  end
end
