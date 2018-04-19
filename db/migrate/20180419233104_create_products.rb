class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.boolean :product_active
      t.integer :inventory
      t.string :photo_url
      t.string :description

      t.timestamps
    end
  end
end
