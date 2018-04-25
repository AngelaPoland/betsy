require "test_helper"

describe ProductsController do
  let(:products) { Product.where(product_active: true) }
  let(:sage) { products(:sage) }
  let(:clothes) { categories(:clothes) }
  let(:ange) { merchants(:ange) }

  describe "root" do
    it "succeeds for active products" do
      get root_path
      must_respond_with :success
    end

    it "succeeds for no active products" do
      products.each do |product|
        product.update_attributes(product_active: false)
      end
      get root_path
      must_respond_with :success
    end

    it "succeeds if there are no products" do
      products.each do |product|
        product.destroy
      end
      get root_path
      must_respond_with :success
    end
  end

  describe "index" do
    it "gets the products index" do
      get products_path
      must_respond_with :success
    end

   it "succeeds when are no products" do
     products.each do |product|
       product.destroy
     end
     get products_path
     must_respond_with :success
   end

   it "gets a merchant's products index" do
     get merchant_products_path(ange)
     must_respond_with :success
   end

   it "renders 404 if merchant doesn't exist" do
     get merchant_products_path(888)
     must_respond_with :not_found
   end

   it "gets a category's products index" do
     get category_products_path(clothes.id)
     must_respond_with :success
   end

   it "renders a 404 if category id doesn't exist" do
     get category_products_path(888)
     must_respond_with :not_found
   end
  end

  describe "show" do
    it "gets an individual product's page" do
     get product_path(2)
     must_respond_with :success
   end

   it "redirects to all products index if specific product doesn't exist" do
     get product_path(567)
     must_respond_with :redirect
     must_redirect_to products_path
   end


  end

  describe "new" do

  end

  describe "create" do

  end

  describe "edit" do

  end

  describe "update" do

  end

end
