class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true
  validates_inclusion_of :rating, numericality: true, in: (1..5)

end
