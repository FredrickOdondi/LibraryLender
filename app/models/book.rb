# app/models/book.rb
class Book < ApplicationRecord
  has_many :borrowings

  def borrowed?
    borrowings.where(returned: false).exists?
  end

  def borrowed_by
    borrowing = borrowings.find_by(returned: false)
    borrowing.user if borrowing
  end
end
