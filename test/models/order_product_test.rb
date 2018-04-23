require "test_helper"

describe OrderProduct do
  let(:order_product) { order_products(:order_01) }

  describe "validations" do
    it "must be valid" do
      order_product.must_be :valid?
      order_product.quantity.must_be_kind_of Integer
    end

    it "must not be valid without a quantity" do
      order_product.quantity = nil
      order_product.valid?.must_equal false
    end

    it "must not be valid with a non-integer quantity" do
      order_product.quantity = "foo"
      order_product.valid?.must_equal false
    end

    it "will be invalid if quantity is less than 1" do
      order_product.quantity = 0
      order_product.valid?.must_equal false
    end

    it "must not be valid if it doesn't have a status" do
      order_product.status = nil
      order_product.valid?.must_equal false

    end

    it "must not be valid if it doesn't have a status of pending, paid, or complete" do
      order_product.status = "someotherstatus"
      order_product.valid?.must_equal false
    end
  end

  describe "relationships" do

    it 'must belong to a product' do
      order_product.must_respond_to :product
      order_product.product.must_be_kind_of Product
      order_product.product.name.must_equal "kombucha"
      order_product.product.must_equal products(:kombucha)
    end

    it 'must belong to a order' do
      order_product.must_respond_to :order
      order_product.order.must_be_kind_of Order
      order_product.order.id.must_equal orders(:order_one).id
      order_product.order.must_equal orders(:order_one)
    end

  end

  describe "custom methods" do

    describe "calculate_cost method" do
      let(:first_order) { order_products(:order_02) }
      let(:second_order) { order_products(:order_03) }

      it "returns an integer" do
        first_order.calculate_cost.must_be_kind_of Integer
      end

      it "must calculate cost correctly" do
        first_order.calculate_cost.must_equal 78
        second_order.calculate_cost.must_equal 117
      end

    end

  end

end
