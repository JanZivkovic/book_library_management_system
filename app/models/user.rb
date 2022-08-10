class User < ApplicationRecord
  require 'securerandom'

  has_secure_password

  belongs_to :role
  has_many :book_loans

  validates :email, presence: true
  validates :password, presence: true
  validates :username, presence:true, uniqueness: true
end
