class CartDetail
  include Mongoid::Document

  field :sku, type: String

  belongs_to :cart
end
