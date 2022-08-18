class BookSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :hard_copies_count
  belongs_to :author
end
