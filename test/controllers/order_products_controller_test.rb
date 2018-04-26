require "test_helper"
require "pry"

describe OrderProductsController do
  let(:mads) { merchants(:mads) }
  describe "update" do
    let(:order_product) { order_products(:order_04) }
    it "redirects and updates an order_products status when merchant logged on" do
      login(mads)

      patch order_product_path(order_product.id, status: "shipped")
      updated_order_product = OrderProduct.find_by(id: order_product.id)

      updated_order_product.status.must_equal "shipped"
      must_respond_with :redirect
      must_redirect_to order_fulfillment_path

      # why you no work!!!!
      # grrrr...... not passing
    end

    it "redirects to root page if no merchant is logged in" do
      patch order_product_path(order_product.id, status: "shipped")

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "redirects to order_fulfillment page if product is invalid" do
      login(mads)

      patch order_product_path("nil", status: "shipped")

      must_respond_with :redirect
      must_redirect_to order_fulfillment_path
    end

    it "redirects to order_fulfillment page if status is invalid" do
      login(mads)

      patch order_product_path(order_product.id, status: "blah")

      must_respond_with :redirect
      must_redirect_to order_fulfillment_path
    end

    it "redirects to order_fulfillment page if current_merchant is not owner of order product" do
      login(merchants(:kat))

      patch order_product_path(order_product.id, status: "shipped")
      updated_order_product = OrderProduct.find_by(id: order_product.id)

      updated_order_product.status.must_equal "paid"
      must_respond_with :redirect
      must_redirect_to order_fulfillment_path

      # currently not passing for the right reasons
    end
  end

  describe "destroy" do
    let(:order_product_2) { order_products(:order_05) }
    it "redirects to cart and successfully destroy order_product record" do

      proc { delete order_product_path(order_product_2.id), session: {order_id: orders(:order_one).id} }.must_change "OrderProduct.count", -1

      must_respond_with :redirect
      must_redirect_to cart_path
    end
    it "redirects to cart and handles if order_product is invalid" do
      proc { delete order_product_path(" ") }.wont_change "OrderProduct.count"

      must_respond_with :redirect
      must_redirect_to cart_path
    end
    it "redirects to cart and handles if order_product status is not pending" do
      proc { delete order_product_path(orders(:order_04).id) }.wont_change "OrderProduct.count"

      must_respond_with :redirect
      must_redirect_to cart_path
    end
    it "redirects to cart and handles if order_product is not a part of cart" do
      proc { delete order_product_path() }.wont_change "OrderProduct.count"

      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end
end
