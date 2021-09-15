class Cart
  include Mongoid::Document

  field :user_id, type: String
  field :status, type: String
  field :item, type: Array, default:[] # insert multiple sku

  has_many :cartDetail
  
end
