class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :fullname, type: String
  field :email, type: String
  field :gender, type: String
  field :password_digest, type: String

  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, :length => { :minimum => 9 }, :on => :register 

  has_secure_password
end
