require "test_helper"
require "pry"

describe Order do
  let(:order) { Order.new }

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
end
