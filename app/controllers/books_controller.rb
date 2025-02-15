class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def borrow
    @book = Book.find(params[:id])
    if @book.borrowings.where(returned: false).exists?
      redirect_to books_path, alert: 'This book is already borrowed.'
    else
      borrowing = current_user.borrowings.create(book: @book, due_date: 2.weeks.from_now.to_date, returned: false)
      redirect_to user_profile_path, notice: 'You have successfully borrowed this book.'
    end
  end

  def return_book
    borrowing = current_user.borrowings.find_by(book_id: params[:id], returned: false)
    if borrowing
      borrowing.update(returned: true)
      redirect_to user_profile_path, notice: 'You have successfully returned the book.'
    else
      redirect_to user_profile_path, alert: 'You did not borrow this book.'
    end
  end
end
