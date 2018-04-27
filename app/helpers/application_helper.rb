module ApplicationHelper

  def total
    price = Product.find(session[:order_id].to_a).collect{|product| product.price}.sum
  end

  def format_price(price)
    sprintf('%.2f', price)
  end
end
