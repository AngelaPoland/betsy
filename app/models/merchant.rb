class Merchant < ApplicationRecord
  has_many :products
  has_many :order_products, through: :product

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    return Merchant.new(provider: auth_hash[:provider], uid: auth_hash[:uid], email: auth_hash[:info][:email], username: auth_hash[:info][:nickname])
  end

end
