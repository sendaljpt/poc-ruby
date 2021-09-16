class CartDetail
  include Mongoid::Document

  field :sku, type: String
  field :quantity, type: Integer
  field :price, type: Float

  belongs_to :cart
end
