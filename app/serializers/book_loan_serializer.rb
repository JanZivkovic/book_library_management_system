class BookLoanSerializer
  include JSONAPI::Serializer
  attributes :id, :start_date, :end_date
  has_one :user
  has_one :book
end
