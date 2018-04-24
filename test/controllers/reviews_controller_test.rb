require "test_helper"

describe ReviewsController do
  let(:product) { products(:kombucha) }

  describe "new" do
    it "succeeds" do
      get new_product_review_path(product.id)
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new product review for valid data" do
      proc {
        post product_reviews_path(product.id), params: {
          review: {
            rating: 1,
            description: "Super bad"
          }
        }
      }.must_change 'Review.count', 1

      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end

    it "does not create a new review with bogus data" do
      proc {
        post product_reviews_path(product.id), params: {
          review: {
            rating: "one",
            description: "Super bad"
          }
        }
      }.wont_change 'Review.count'
    end

    it "does not allow merchant to review her own products" do
      merchant = merchants(:mads)
      login(merchant)
      proc {
        post product_reviews_path(product.id), params: {
          review: {
            rating: 4,
            description: "Super good"
          }
        }
      }.wont_change 'Review.count'
      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end
  end
end
