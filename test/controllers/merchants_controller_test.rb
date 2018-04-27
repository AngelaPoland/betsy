require "test_helper"

describe MerchantsController do
  let(:meka) { merchants(:kat) }
  let(:mads) { merchants(:mads) }
  describe 'account_page' do

    it 'successfully gets account_page view if merchant is logged in' do
      login(mads)

      get account_page_path

      must_respond_with :success
    end

    it 'successfully gets account_page if has products have no order_products' do
      login(meka)

      get account_page_path

      must_respond_with :success
    end

    it 'successfully gets account_page if has no products' do
      meka.products.each { |product| product.destroy }
      login(meka)

      get account_page_path

      must_respond_with :success
    end

    it 'redirects to root if no merchant is logged in' do
      get account_page_path

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it 'redirects to root if merchant has logged out' do
      # based on Media Ranker Revisited
      # necessary?
    end
  end

  describe 'order_fulfillment' do
    it 'successfully gets order_fulfillment view if merchant is logged in' do
      login(mads)

      get order_fulfillment_path

      must_respond_with :success
    end

    it 'successfully gets order_fulfillment view if merchant has no orders' do
      login(meka)

      get order_fulfillment_path

      must_respond_with :success
    end

    it 'successfully gets filtered products_manager view if valid filter applied' do
      login(mads)

      get products_manager_path, params: { status: "shipped" }

      must_respond_with :success
    end

    it 'successfully gets all products_manager view if invalid filter applied' do
      login(mads)

      get products_manager_path, params: { status: "blah" }

      must_respond_with :success
      # this seems unnecessary in the way it is tested
      # is there another way to test with scope/filtered views?
    end

    it 'redirects to root if no merchant is logged in' do
      get order_fulfillment_path

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it 'redirects to root if merchant has logged out' do
      # based on Media Ranker Revisited
      # necessary?
    end
  end

  describe 'products_manager' do
    it 'successfully gets products_manager view if merchant is logged in' do
      login(meka)

      get products_manager_path

      must_respond_with :success
    end

    it 'successfully gets products_manager view if merchant has no products' do
      meka.products.each do | product |
        product.destroy
      end
      login(meka)

      get products_manager_path

      must_respond_with :success
    end

    it 'redirects to root if no merchant is logged in' do
      get products_manager_path

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it 'redirects to root if merchant has logged out' do
      # based on Media Ranker Revisited
      # necessary?
    end
  end

end
