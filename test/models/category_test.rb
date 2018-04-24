require "test_helper"

describe Category do
  let(:category) { categories(:clothes) }

  describe "validations" do

    it "must be valid" do
      category.must_be :valid?
    end

    it "must be invalid without a category_name" do
      category.category_name = nil
      category.valid?.must_equal false
    end

    it "must be invalid if it has a duplicate name" do
      category2 = categories(:extra)
      category2.category_name = "Clothing"
      category2.valid?.must_equal false
    end

  end

  describe "relationships" do

    it "has and belongs to products" do
      category1 = categories(:food)

      product = Product.find_by(name: "kombucha")
      category1.must_respond_to :products
      category1.products.must_include product
      category.products.length.must_equal 2
    end

    it "can have no products" do
      category.valid?.must_equal true
    end

  end


end
