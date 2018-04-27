require "test_helper"

describe SessionsController do
  describe "login" do

    it "logs in an existing user and redirects to the root route" do
      existing_merchant = merchants(:mads)

      start_count = Merchant.count

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(existing_merchant))
      # here ^ mock_auth is not a path or method thats being called - its part of the overall way OmniAuth is used..?

      get auth_callback_path(existing_merchant.provider)

      Merchant.count.must_equal start_count
      must_redirect_to root_path
      session[:merchant_id].must_equal existing_merchant.id
    end

    it "must create a new user and redirects to the root route" do
      new_merchant = Merchant.new(
        provider: 'github',
        uid: 666,
        username: 'new test merchant',
        email: 'test@test.com'
      )

      proc {
      login(new_merchant) }.must_change 'Merchant.count', 1

      must_redirect_to root_path
    end

    it "fails if a user is already logged in and a user attempts to log in" do
      existing_merchant = merchants(:mads)
      login(existing_merchant)

      proc {
      login(existing_merchant) }.wont_change 'Merchant.count'

      must_redirect_to root_path

    end

    it "redirects to the root route and doesn't create new user if given invalid user data" do
      bad_merchant = Merchant.new(
        provider: 'github',
        uid: 666,
        email: 'test@test.com'
      )

      proc {
      login(bad_merchant) }.must_change 'Merchant.count', 0

      must_redirect_to root_path
    end

    it "redirects to the root route and doesn't create new user if given invalid user data" do
      bad_merchant = Merchant.new(
        provider: 'github',
        uid: nil,
        username: 'new test merchant',
        email: 'test@test.com'
      )

      proc {
      login(bad_merchant) }.must_change 'Merchant.count', 0

      must_redirect_to root_path
    end
  end

  describe "logout" do

  it "can log out a logged in user" do
    #login user from fixtures
    login(merchants(:nora))
    delete logout_path

    session[:merchant_id].must_be_nil
    must_redirect_to root_path
  end

end

end
