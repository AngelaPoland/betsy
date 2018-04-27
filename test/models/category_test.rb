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
      amaretto = Product.create(
        name: "amaretto",
        price: 39,
        description: "almond goodness",
        product_active: true,
        inventory: 31,
        merchant: merchants(:kat),
      )
      alcohol = Category.create(
        category_name: "libations",
        product_ids: [amaretto.id]
      )

      alcohol.products.must_include amaretto
      alcohol.products.length.must_equal 1
    end

    it "can have no products" do
      category.valid?.must_equal true
    end

  end


end
