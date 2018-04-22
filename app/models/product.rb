class Product < ApplicationRecord
  has_many :order_products
  has_and_belongs_to_many :categories
  has_many :reviews
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than: 1000000 }
  validates_numericality_of :inventory, :only_integer => true, :greater_than_or_equal_to => 0

  def average_rating
    num_of_ratings = 0
    total = 0.0
    self.reviews.each do |review|
      total += review.rating
      num_of_ratings += 1
    end
    average = (total/num_of_ratings)
    return average
  end
end
