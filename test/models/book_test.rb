require "test_helper"

class BookTest < ActiveSupport::TestCase

  test "create book with unknown author generates error" do
    book = Book.create({author_id: 9, title:'Book of unknown author', hard_copies_count:1})
    assert_equal(book.errors[:author].first, 'must exist', 'Mandatory author not validated')
  end


  test "valid book successfully created" do
    book = Book.new({title: 'The Light Fantastic', author:authors(:terry_pratchett), hard_copies_count:2})
    assert(book.save, 'Valid book not created')
  end

  test "available to loan return true" do
    book = books(:mort)
    assert book.available_to_loan? Date.new(2022,8,10)
  end

  test "available to loan return false" do
    book = books(:the_colour_of_magic)
    assert_not (book.available_to_loan? Date.new(2022,8,10))
  end
end
