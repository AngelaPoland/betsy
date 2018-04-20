class Review < ApplicationRecord

  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true, in: 1..5 }


end
