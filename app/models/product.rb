class Product < ApplicationRecord
  has_many :order_products
  has_and_belongs_to_many :catergories
  has_many :reviews
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than: 1000000 }
  validates_numericality_of :inventory, :only_integer => true, :greater_than_or_equal_to => 0

end
