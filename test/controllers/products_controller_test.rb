require "test_helper"

describe ProductsController do
  describe "root" do
    it "succeeds for active products" do
      get root_path
      must_respond_with :success
    end

    it "succeeds for no active products" do
      products = Product.where(product_active: true)
      products.each do |product|
        product.update_attributes(product_active: false)
      end
      get root_path
      must_respond_with :success
    end

    it "succeeds if there are no products" do
      products = Product.where(product_active: true)
      products.each do |product|
        product.destroy
      end
      get root_path
      must_respond_with :success
    end
  end

  describe "index" do

  end

  describe "show" do

  end

  describe "new" do

  end

  describe "create" do

  end

  describe "should get edit" do

  end

  describe "should get update" do

  end

end
