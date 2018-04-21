class ChangeBillingNumToString < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :billing_num, :string
  end
end
