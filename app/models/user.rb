class User < ApplicationRecord
  require 'securerandom'

  has_secure_password

  belongs_to :role
  has_many :book_loans

  validates :email, presence: true
  validates :password, presence: true
  validates :username, presence:true, uniqueness: true


  def can_make_a_loan? date
    self.book_loans.where("date(:date) >= book_loans.start_date and book_loans.end_date is null", {date: date}).count < 3
  end
end
