require "test_helper"

describe MerchantsController do
  it "should get account_page" do
    get merchants_account_page_url
    value(response).must_be :success?
  end

  it "should get order_fulfillment" do
    get merchants_order_fulfillment_url
    value(response).must_be :success?
  end

  it "should get products_manager" do
    get merchants_products_manager_url
    value(response).must_be :success?
  end

end
