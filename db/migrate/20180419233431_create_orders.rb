class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :billing_email
      t.string :billing_address
      t.string :billing_name
      t.integer :billing_num
      t.string :billing_exp
      t.integer :billing_cvv
      t.integer :billing_zipcode

      t.timestamps
    end
  end
end
