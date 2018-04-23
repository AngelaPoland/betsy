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

end
