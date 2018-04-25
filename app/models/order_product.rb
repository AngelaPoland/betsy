class OrderProduct < ApplicationRecord
  STATUS = ["pending", "paid", "cancelled", "shipped"]

  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :status, presence: true, inclusion: {in: STATUS}

  def calculate_cost
    self.product.price * self.quantity
   end

   def pending_order?
       return self.status == "paid"
   end

end
