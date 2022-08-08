class BookLoan < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :start_date, presence: true, comparison: { greater_than_or_equal: :end_date }
  validates :end_date, presence: true, comparison: { less_than_or_equal: :end_date }
  validates :book, presence: true
  validates :user, presence: true
end
