class Product
  include Mongoid::Document

  field :name, type: String
  field :description, type: String

  belongs_to :store
  has_many :variant
end
