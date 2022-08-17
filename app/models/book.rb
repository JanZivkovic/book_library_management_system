class Book < ApplicationRecord
  belongs_to :author
  has_many :book_loans

  validates :title, presence: true
  validates :hard_copies_count, presence:true, comparison: { greater_than_or_equal_to: 0 , message: 'Hard copies count must be a positive number.'}
  validates :title, uniqueness: { scope: :author_id, message: "Book with this title and author already exists." }

  def self.out_of_stock (date)
    self.find_by_sql ['
        select
          books.id,
          books.title,
          books.hard_copies_count,
          books.author_id,
          count(book_loans.id)
        from
          books
        join
          book_loans on
            book_loans.book_id = books.id
        where
          date(:date) >= book_loans.start_date
          and
          (book_loans.end_date is null or date(:date) <= book_loans.end_date)
        group by
          books.id,
          books.title,
          books.hard_copies_count,
          books.author_id
        having
          count(book_loans.id) = books.hard_copies_count
      ', {date: date}]
  end

  def available_to_loan? date
    self.book_loans.where("? between book_loans.start_date and book_loans.end_date", date).count < self.hard_copies_count
  end
end
