require "test_helper"

describe Review do
  let(:review) { Review.new }

  describe "validations" do
    it "must be valid" do
      review1 = reviews(:review1)
      review1.rating.class.must_equal Integer
      review1.valid?.must_equal true
    end

    it "must be invalid if rating is blank" do
      review2 = reviews(:review2)
      review2.rating = nil
      review2.valid?.must_equal false
    end

    it "must be invalid if rating is a string" do
      review3 = reviews(:review3)
      review3.rating = 'mystring'
      review3.valid?.must_equal false
    end

    it "must be invalid if rating is less than 1" do
      review4 = reviews(:review4)
      review4.rating = 0
      review4.valid?.must_equal false
    end

    it "must be invalid if rating is greater than 5" do
      review1 = reviews(:review1)
      review1.rating = 6
      review1.valid?.must_equal false
    end

    it "must be valid if description is nil" do
      review2 = reviews(:review2)
      review2.description = nil
      review2.valid?.must_equal true
    end
  end

  describe 'relations' do

    it 'must have a Product' do
      review1 = reviews(:review1)
      review1.must_respond_to :product
      review1.product.must_be_kind_of Product
      review1.product.name.must_equal "man bun"
      review1.product.must_equal products(:manbun)
    end

  end
end
