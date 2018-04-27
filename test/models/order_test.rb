require "test_helper"
require "pry"

describe Order do
  let(:order) { Order.new }
  let(:order_five) { orders(:order_five) }

  describe "validations" do
    it "must be valid" do
      order_one = orders(:order_one)
      order_one.valid?.must_equal true
    end

    it "must be valid when billing info is blank and status is nil" do
      order_five = orders(:order_five)
      order_five.valid?.must_equal true
    end

    it "must be valid when billing info is filled and status is paid or complete" do
      order_four = orders(:order_four)
      order_four.valid?.must_equal true
    end

    it "must be invalid when billing info is blank and status is paid or complete" do
      order_five = orders(:order_five)
      order_five.status = "paid"
      order_five.valid?.must_equal false
    end
  end

  describe "calculate_total" do
    let(:order_one) { orders(:order_one) }

    it "returns total cost of an order" do
      order_one.calculate_total.must_equal 273
    end

    it "returns 0 when there are no order_products" do
      order_five.calculate_total.must_equal 0
    end
  end
end
