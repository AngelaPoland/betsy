require "test_helper"

describe ProductsController do
  let(:products) { Product.where(product_active: true) }
  let(:sage) { products(:sage) }
  let(:clothes) { categories(:clothes) }
  let(:ange) { merchants(:ange) }
  let(:kat) { merchants(:kat) }
  let(:user) { merchants(:user) }
  let(:mads) { merchants(:mads) }
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
     id = Product.find_by(name: "sage").id

     get product_path(id)

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

      must_respond_with :redirect
      must_redirect_to new_merchant_product_path(nora.id)
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
      updated_product = Product.find_by(name: "blue hoodie")

      updated_product.name.must_equal "blue hoodie"
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

      unchanged_product = Product.find_by(name: "man bun")

      unchanged_product.name.must_equal "man bun"
      must_respond_with :redirect
      must_redirect_to edit_merchant_product_path(nora.id, product.id)
    end

    it "renders 404 not_found for a bogus product ID" do
      login(nora)
      product = Product.find_by(name: "kale chips")
      product.id = "notanid"
      put merchant_product_path(nora.id, product.id)
      must_respond_with :not_found
    end
  end

  describe "add to order" do
    it "succeeds for extant, in-stock product" do
      product = Product.find_by(name: "kale chips")
      proc {
        get add_to_order_path(product.id), params: {
          order_products: {
            inventory: 3
          }
        }
      }.must_change 'OrderProduct.count', 1
      product = Product.find_by(name: "kale chips")
      product.inventory.must_equal 31
      order_product = OrderProduct.last
      order_product.status.must_equal "pending"
      order = Order.last
      order.order_products.last.quantity.must_equal 3
      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end


    it "fails for a non-existant product" do
      kalechips = Product.find_by(name: "kale chips")
      kalechips.id = 78
      proc {
        get add_to_order_path(kalechips.id), params: {
          order_products: {
            inventory: 6
          }
        }
      }.wont_change 'OrderProduct.count'
    end

    it "fails for a request that is greater than the inventory available" do
      chemex = Product.find_by(name: "chemex")
      proc {
        get add_to_order_path(chemex.id), params: {
          order_products: {
            inventory: 87
          }
        }
      }.wont_change 'OrderProduct.count'
    end

    it "fails for a request to add 0 products to cart" do
      chemex = Product.find_by(name: "chemex")
      proc {
        get add_to_order_path(chemex.id), params: {
          order_products: {
            inventory: 0
          }
        }
      }.wont_change 'OrderProduct.count'
    end

    it "does not allow merchant to add her own products to cart" do
      login(kat)
      chemex = Product.find_by(name: "chemex")
      proc {
        get add_to_order_path(chemex.id), params: {
          order_products: {
            inventory: 5
          }
        }
      }.wont_change 'OrderProduct.count'
    end

    it "fails when product status is retired" do
      login(mads)
      kombucha = Product.find_by(name: "kombucha")
      kombucha.product_active = false
      kombucha.save
      proc {
        get add_to_order_path(kombucha.id), params: {
          order_products: {
            inventory: 9
          }
        }
      }.wont_change 'OrderProduct.count'
    end

    it "fails when product is out of stock" do
      root_path
      saltlamp = Product.find_by(name: "salt lamp")
      proc {
        get add_to_order_path(saltlamp.id), params: {
          order_products: {
            inventory: 5
          }
        }
      }.wont_change 'OrderProduct.count'
    end
  end

  describe "product_status" do
    it "updates a product's status" do
      login(kat)
      merchant = Merchant.find_by(username: "kat")
      chemex = Product.find_by(name: "chemex")
      patch product_status_path(merchant.id, chemex.id), params: { product_active: false }

      chemex = Product.find_by(name: "chemex")

      chemex.product_active.must_equal false
    end
  end
end
