class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true, in: 1..5 }

end
