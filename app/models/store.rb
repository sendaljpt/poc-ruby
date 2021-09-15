class Store
  include Mongoid::Document

  field :name, type: String
  field :address, type: String

  has_many :product
end
