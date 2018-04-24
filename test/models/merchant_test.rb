require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }

  describe "validations" do

    it "requires a username" do
      mads = merchants(:mads)
      mads.username = nil
      mads.valid?.must_equal false
      mads.errors.messages.must_include :username
    end

    it "requires a unique username" do
      nora = merchants(:nora)
      ange = merchants(:ange)
      ange.username = "nora"
      ange.valid?.must_equal false
      ange.errors.messages.must_include :username
    end

    it "requires an email" do
      kat = merchants(:kat)
      kat.email = nil
      kat.valid?.must_equal false
      kat.errors.messages.must_include :email
    end

    it "requires a unique email" do
      kat = merchants(:kat)
      mads = merchants(:mads)
      kat.email = "mads@mads.com"
      kat.valid?.must_equal false
      kat.errors.messages.must_include :email
    end
  end

  describe "relations" do

    it "has a list of products" do
      user = merchants(:user)
      user.must_respond_to :products
      user.products.each do |product|
        product.must_be_kind_of Product
      end
    end
  end

  describe "custom methods" do

    describe "self.build_from_github" do

      it "returns a new merchant" do

        new_hash = {
          provider: "github",
          uid: 12345,
          info: {email: "angela@test.com",
          nickname: "testyaself" }
        }

        new_merchant = Merchant.build_from_github(new_hash)
        
        new_merchant.must_be_instance_of Merchant
        new_merchant.valid?.must_equal true

      end

    end

  end
end
