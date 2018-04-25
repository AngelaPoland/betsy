class Order < ApplicationRecord
  has_many :order_products

  validates :billing_email, presence: true, if: :paid?
  validates :billing_address, presence: true, if: :paid?
  validates :billing_name, presence: true, if: :paid?
  validates :billing_num, presence: true, length: { in: 16..16 }, if: :paid?
  validates :billing_exp, presence: true, if: :paid?
  validates :billing_cvv, presence: true, if: :paid?
  validates :billing_zipcode, presence: true, length: { in: 5..5 }, if: :paid?

  def paid?
    self.status == "paid"
  end

  # validates_inclusion_of :rating, in: (1..5), allow_nil: true

  def calculate_total
    total = 0
    self.order_products.each do |order_product|
      total += order_product.calculate_cost
    end
    total
  end

  def find_order_merchants
    find_order_merchants = []
    self.order_products.each do |order_product|
      find_order_merchants << order_product.product.merchant
    end
    return find_order_merchants
  end

  def completed_order?
    self.order_products.each do |order_product|
      if order_product.status != "shipped"
        return false
      end
    end
    return true
  end

end
