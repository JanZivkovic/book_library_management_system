class ChangeHardCopiesCountFromStringToIntegerOnBook < ActiveRecord::Migration[7.0]
  def change
    change_column(:books, :hard_copies_count, :integer)
  end
end
