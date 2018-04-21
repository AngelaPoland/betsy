class Category < ApplicationRecord

  has_and_belongs_to_many :products

  validates :category_name, presence: true, uniqueness: true


  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end


end
