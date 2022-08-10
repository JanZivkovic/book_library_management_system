class BookLoan < ApplicationRecord
  belongs_to :book
  belongs_to :user


  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :book, presence: true
  validates :user, presence: true

  validate :dates?
  validate :start_date_gr_than_or_eq_to_end_date?

  private
    def dates?
      if start_date.present?
        unless start_date.is_a?(Date)
          errors.add(:start_date, "Is an invalid date.")
        end
      end

      if end_date.present?
        unless end_date.is_a?(Date)
          errors.add(:end_date, "Is an invalid date.")
        end
      end

      errors.empty?
    end

    def start_date_gr_than_or_eq_to_end_date?
      if !(end_date.after? start_date  || start_date == end_date)
        errors.add(:end_date, "must be greater or equal to start date.")
      end
    end
end
