require "test_helper"

describe CategoriesController do
  let(:category) { categories(:beverage) }
  let(:ange) { merchants(:ange) }

  describe "new" do

    it "succeeds" do
      login(ange)
      get new_category_path
      must_respond_with :success

    end

  end

  describe "create" do

    it "creates a new category with valid data" do
      login(ange)
      proc {
        post categories_path, params: { category: { category_name: "libations",
        products: "kombucha"   }  }
      }.must_change 'Category.count', 1

      must_respond_with :redirect
      must_redirect_to products_manager_path

    end

    it "will not create a new category with bogus data" do
      login(ange)
      proc {
        post categories_path, params: { category: { category_name: " ",
        products: "kombucha"   }  }
      }.wont_change 'Category.count'
      must_respond_with :error

    end



  end
end
