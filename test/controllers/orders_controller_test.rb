require "test_helper"

describe OrdersController do
  it "should get show" do
    get orders_show_url
    value(response).must_be :success?
  end

  it "should get create" do
    get orders_create_url
    value(response).must_be :success?
  end

  it "should get update" do
    get orders_update_url
    value(response).must_be :success?
  end

  it "should get checkout" do
    get orders_checkout_url
    value(response).must_be :success?
  end

  it "should get paid" do
    get orders_paid_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get orders_destroy_url
    value(response).must_be :success?
  end

end
