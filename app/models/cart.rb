class Cart
  include Mongoid::Document

  field :user_id, type: String
  field :status, type: String

  has_many :cartDetail
end
