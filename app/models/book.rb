class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true
  validates :hard_copies_count, presence:true, comparison: { greater_than_or_equal_to: 0 , message: 'Hard copies count must be a positive number.'}
  validates :title, uniqueness: { scope: :author_id, message: "Book with this title and author already exists." }
end
