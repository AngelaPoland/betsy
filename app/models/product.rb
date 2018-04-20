class Product < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, format: { with: /\A\d+(?:\.\d{2})?\z/ }, numericality: { greater_than: 0, less_than: 1000000 }
  validates_numericality_of :inventory, :only_integer => true, :greater_than_or_equal_to => 0

end
