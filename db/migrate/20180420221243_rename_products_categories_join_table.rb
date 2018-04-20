class RenameProductsCategoriesJoinTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :products_categories, :categories_products
  end
end
