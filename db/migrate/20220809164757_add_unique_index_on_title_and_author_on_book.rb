class AddUniqueIndexOnTitleAndAuthorOnBook < ActiveRecord::Migration[7.0]
  def change
    add_index :books, [:title, :author_id], unique: true
  end
end
