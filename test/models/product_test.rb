require "test_helper"
require 'pry'

describe Product do
  let(:product) { Product.new }

  describe "validations" do
    it "must be valid" do
      kombucha = products(:kombucha)
      kombucha.valid?.must_equal true
      kombucha.inventory.class.must_equal Integer
    end

    it "requires a product name" do
      sage = products(:sage)
      sage.name = nil
      sage.valid?.must_equal false
    end

    it "requires a unique product name" do
      sage = products(:sage)
      sage2 = Product.new(name: "sage", price: 9)
      sage2.save
      sage2.valid?.must_equal false
      sage2.errors.messages.must_include :name
    end

    it "requires a price" do
      hoodie = products(:hoodie)
      hoodie.price = nil
      hoodie.valid?.must_equal false
    end

    it "must be invalid if price is 0 or negative number" do
      kale_chips = products(:kale_chips)
      kale_chips.price = 0
      chemex = products(:chemex)
      chemex.price = -43
      kale_chips.valid?.must_equal false
      chemex.valid?.must_equal false
    end

    it "must be invalid if price is 1000000 or greater" do
      salt_lamp = products(:salt_lamp)
      salt_lamp.price = 1000000
      salt_lamp.valid?.must_equal false
    end

    it "requires inventory to be an integer greater than or equal to zero" do
      chemex = products(:chemex)
      chemex.inventory = -7
      chemex.valid?.must_equal false
    end
  end

  describe "relations" do
    it "must have a merchant" do
      kombucha = products(:kombucha)
      kombucha.must_respond_to :merchant
      kombucha.merchant.must_be_kind_of Merchant
      kombucha.merchant.username.must_equal "mads"
      kombucha.merchant.must_equal merchants(:mads)
    end

    it "has a list of categories" do
      kombucha = products(:kombucha)
      food = categories(:food)
      beverage = categories(:beverage)
      kombucha.categories.must_include food
      kombucha.categories.must_include beverage
      kombucha.categories.length.must_equal 2
    end

    it "has a list of reviews" do
      
    end

    it "has a list of order_products" do

    end
  end
end
