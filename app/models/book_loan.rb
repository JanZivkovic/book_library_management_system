class BookLoan < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :start_date, presence: true
  validates :start_date, comparison: { greater_than_or_equal_to: :end_date }
  validates :end_date, presence: true
  validates :end_date, comparison: { less_than_or_equal_to: :start_date }
  validates :book, presence: true
  validates :user, presence: true
end
