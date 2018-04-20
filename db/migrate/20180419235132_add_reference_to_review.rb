class AddReferenceToReview < ActiveRecord::Migration[5.1]
  def change
    add_reference :reviews, :product, foreign_key: true
  end
end
