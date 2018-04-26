require "test_helper"

describe OrdersController do
  let(:order_three) { orders(:order_three) }

  describe "show" do
    it "show individual orders" do
      get order_path(order_three.id)
      must_respond_with :success
    end
  end

  it "should get create" do
    skip
    get orders_creat
    value(response).must_be :success?
  end

  it "should get update" do
    skip
    get orders_update_url
    value(response).must_be :success?
  end

  it "should get checkout" do
    skip
    get orders_checkout_url
    value(response).must_be :success?
  end

  it "should get paid" do
    skip
    get orders_paid_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    skip
    get orders_destroy_url
    value(response).must_be :success?
  end

end
