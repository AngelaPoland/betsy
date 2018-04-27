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
    end
  end

  describe "destroy" do
    let(:order) { orders(:order_one) }
    it "redirects to cart and successfully destroy order_product record" do
      order_product = order_products(:order_01)

      proc { delete order_order_product_path(order.id, order_product.id) }.must_change "OrderProduct.count", -1

      must_respond_with :redirect
      must_redirect_to cart_path
    end
    it "redirects to cart and handles if order_product is invalid" do
      order_product = order_products(:order_01)
      id = order_product.id
      order_product.destroy

      proc { delete order_order_product_path(order.id, order_product.id) }.wont_change "OrderProduct.count"

      must_respond_with :redirect
      must_redirect_to cart_path
    end
    it "redirects to cart and handles if order status is not pending/nil" do
      order_product = order_products(:order_04)

      proc { delete order_order_product_path(orders(:order_four).id, order_product.id) }.wont_change "OrderProduct.count"

      must_respond_with :redirect
      must_redirect_to cart_path
    end
    it "redirects to cart and handles if order_product is not a part of order" do
      order_product = order_products(:order_04)

      proc { delete order_order_product_path(order.id, order_product.id) }.wont_change "OrderProduct.count"

      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end
end
