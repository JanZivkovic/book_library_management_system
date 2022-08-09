class SetHardCopiesCountNotNullInBook < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:books, :hard_copies_count, false)
  end
end
