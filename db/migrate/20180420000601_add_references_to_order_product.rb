class AddReferencesToOrderProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_products, :order, foreign_key: true
    add_reference :order_products, :product, foreign_key: true
  end
end
