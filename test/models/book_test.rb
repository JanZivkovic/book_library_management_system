require "test_helper"

class BookTest < ActiveSupport::TestCase

  test "create_book_with_unknown_author_generates_error" do
    book = Book.create({author_id: 9, title:'Book of unknown author', hard_copies_count:1})
    assert_equal(book.errors[:author].first, 'must exist', 'Mandatory author not validated')
  end


  test "valid_book_successfully_created" do
    book = Book.new({title: 'The Light Fantastic', author:authors(:terry_pratchett), hard_copies_count:2})
    assert(book.save, 'Valid book not created')
  end
end
