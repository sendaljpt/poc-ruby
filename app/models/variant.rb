class Variant
  include Mongoid::Document

  field :sku, type: String
  field :color, type: String
  field :price, type: Integer

  belongs_to :product
end
