require "test_helper"

describe ProductsController do
  let(:products) { Product.where(product_active: true) }
  let(:sage) { products(:sage) }
  let(:clothes) { categories(:clothes) }
  let(:ange) { merchants(:ange) }
  let(:user) { merchants(:user) }
  let(:nora) { merchants(:nora) }
  let(:hoodie) { products(:hoodie) }

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
    it "gets the new product form for logged-in merchant" do
      login(ange)
      get new_merchant_product_path(ange.id)
      must_respond_with :success
    end

    it "does not get the new product form for guest" do
      get new_merchant_product_path(ange.id)
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "create" do
    it "creates a new product for logged-in merchant, with valid data" do
      login(nora)
      proc {
        post merchant_products_path(nora.id), params: {
          product: {
            name: "newproduct",
            price: 32.67,
            description: "Super awesome new product",
            inventory: 5,
            photo_url: "https://picsum.photos/200/?random"
          }
        }
      }.must_change 'Product.count', 1

      newproduct = Product.find_by(name: "newproduct")
      must_respond_with :redirect
      must_redirect_to product_path(newproduct.id)
    end

    it "does not create a new product for logged-in merchant with bogus data" do
      login(nora)
      proc {
        post merchant_products_path(nora.id), params: {
          product: {
            name: "",
            price: 0,
            description: "Super awesome new product",
            inventory: 0,
            photo_url: "https://picsum.photos/200/?random"
          }
        }
      }.wont_change 'Product.count'

      must_respond_with :error
    end
  end

  describe "edit" do
    it "succeeds for an extant product ID" do
      login(nora)
      product = Product.find_by(name: "hoodie")
      get edit_merchant_product_path(nora.id, product.id)
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus product ID" do
      login(nora)
      product = Product.find_by(name: "hoodie")
      product.id = "notanid"
      get edit_merchant_product_path(nora.id, product.id)
      must_respond_with :not_found
    end

  end

  describe "update" do
    it "succeeds for valid data and an extant product ID and logged-in user" do
      login(nora)
      product = Product.find_by(name: "hoodie")
      put merchant_product_path(nora.id, product.id), params: {
        product: {
          name: "blue hoodie",
          price: 23.67,
          description: "Super awesome new product",
          inventory: 3,
          photo_url: "https://picsum.photos/200/?random"
        }
      }
      updated_work = Product.find_by(id: 3)

      updated_work.name.must_equal "blue hoodie"
      must_respond_with :redirect
    end

    it "fails for bogus data and an extant product ID and logged-in user" do
      login(nora)
      product = Product.find_by(name: "man bun")
      put merchant_product_path(nora.id, product.id), params: {
        product: {
          name: "",
          price: 0,
          description: "Super awesome new product",
          inventory: 0,
          photo_url: "https://picsum.photos/200/?random"
        }
      }
      must_respond_with :error
    end

    it "renders 404 not_found for a bogus product ID" do
      login(nora)
      product = Product.find_by(name: "kale chips")
      product.id = "notanid"
      put merchant_product_path(nora.id, product.id)
      must_respond_with :not_found
    end
  end
end
