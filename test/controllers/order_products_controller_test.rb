require "test_helper"

describe OrderProductsController do
  it "should get edit" do
    get order_products_edit_url
    value(response).must_be :success?
  end

  it "should get update" do
    get order_products_update_url
    value(response).must_be :success?
  end

end
