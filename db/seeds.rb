# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

CATEGORY_FILE = Rails.root.join('db','seed-data', 'category-seeds.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id']
  category.category_name = row['category_name']
  puts "Created category: #{category.inspect}"
  successful = category.save
  if !successful
    category_failures << category
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categorys failed to save"
puts
puts

ORDER_FILE = Rails.root.join('db','seed-data', 'orders-seeds.csv')
puts "Loading raw order data from #{ORDER_FILE}"


order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.id = row['id']
  order.status = row['status']
  order.billing_name = row['billing_name']
  order.billing_email = row['billing_email']
  order.billing_address = row['billing_address']
  order.billing_zipcode = row['billing_zipcode']
  order.billing_num = row['billing_num']
  order.billing_exp = row['billing_exp']
  order.billing_cvv = row['billing_cvv']
  puts "Created order: #{order.inspect}"
  successful = order.save
  if !successful
    order_failures << order
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"
p order_failures
puts

MERCHANT_FILE = Rails.root.join('db','seed-data', 'merchant-seeds.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.id = row['id']
  merchant.username = row['username']
  merchant.email = row['email']
  merchant.uid = row['uid']
  merchant.provider = row['provider']
  puts "Created merchant: #{merchant.inspect}"
  successful = merchant.save
  if !successful
    merchant_failures << merchant
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"
puts
puts


PRODUCT_FILE = Rails.root.join('db','seed-data', 'product-seeds.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.inventory = row['inventory']
  product.description = row['description']
  product.photo_url = row['photo_url']
  product.product_active = row['product_active']
  product.merchant_id = row['merchant_id']
  puts "Created product: #{product.inspect}"
  successful = product.save
  if !successful
    product_failures << product
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"
puts
puts

REVIEW_FILE = Rails.root.join('db','seed-data', 'review-seeds.csv')
puts "Loading raw review data from #{REVIEW_FILE}"

review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.id = row['id']
  review.rating = row['rating']
  review.product_id = row['product_id']
  review.description = row['description']
  puts "Created review: #{review.inspect}"
  successful = review.save
  if !successful
    puts review.errors
    review_failures << review
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"
p review_failures
puts


OP_FILE = Rails.root.join('db','seed-data', 'order-product-seeds.csv')
puts "Loading raw order_product data from #{OP_FILE}"

order_product_failures = []
CSV.foreach(OP_FILE, :headers => true) do |row|
  order_product = OrderProduct.new
  order_product.order_id = row['order_id']
  order_product.product_id = row['product_id']
  order_product.quantity= row['quantity']
  order_product.status = row['status']
  puts "Created order_product: #{order_product.inspect}"
  successful = order_product.save
  if !successful
    order_product_failures << order_product
  end
end

puts "Added #{OrderProduct.count} order-product records"
puts "#{order_product_failures.length} order_product failed to save"
p order_product_failures
puts

CP_FILE = Rails.root.join('db','seed-data', 'category-product-seeds.csv')
puts "Loading raw category_product data from #{CP_FILE}"

category_product_failures = []
CSV.foreach(CP_FILE, :headers => true) do |row|
  prd = Product.find(row['product_id'])
  cat = Category.find(row['category_id'])
  prd.categories << cat
end


puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
