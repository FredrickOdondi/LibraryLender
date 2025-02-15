# Library Management System🤖👽
![Alt Text](https://github.com/user-attachments/assets/5a07e157-307b-4117-abc1-b666b7720f4d)

## Overview
This is a **Library Management System** built using **Ruby on Rails**, designed as my first hands-on project with the framework. As a backend Java developer transitioning into Ruby on Rails, I found this framework to be incredibly productive, offering rapid development with minimal boilerplate code. The system allows users to borrow and return books while demonstrating key aspects of **CRUD (Create, Read, Update, Delete)** operations, **Active Record associations**, and basic authentication.

The application includes features such as user registration, book browsing, borrowing logic, and returning borrowed books. It leverages Rails' convention-over-configuration philosophy to streamline development and ensure maintainability.

---

## Key Features

1. **User Authentication:**
   - Users can sign up, log in, and log out securely.
   - User profiles display a list of currently borrowed books.

2. **Books Management:**
   - A list of available books is displayed with their title, author, and ISBN.
   - Users can view detailed information about each book, including its availability status.

3. **Borrowing Books:**
   - Users can borrow available books by clicking a "Borrow" button.
   - If a book is already borrowed, the "Borrow" button is disabled, and a message indicates its unavailability.

4. **Returning Books:**
   - Users can return borrowed books from their profile page.
   - Returning a book updates its availability status in the system.

5. **Borrowing Logic:**
   - The system ensures that only one user can borrow a book at a time.
   - Borrowed books are tracked with a due date (set to 2 weeks from the borrowing date).

6. **Error Handling:**
   - Proper error messages are displayed if a user tries to borrow an unavailable book or performs invalid actions.

---

## Technologies Used

- **Ruby on Rails**: Version 7.0 (or higher).
- **SQLite**: Local database for development and testing.
- **Devise**: Gem for handling user authentication.
- **Bootstrap**: Front-end framework for responsive and styled UI.
- **HTML/CSS/ERB**: For structuring and styling views.
- **RSpec** (optional): For testing the application's functionality.

---

## Code Highlights

### 1. **Model Associations**
The system uses Active Record associations to define relationships between models. Below is an example of how the `Book`, `User`, and `Borrowing` models are related:

```ruby
# app/models/book.rb
class Book < ApplicationRecord
  validates :title, :author, :isbn, presence: true
  validates :isbn, uniqueness: true

  has_many :borrowings
  has_many :users, through: :borrowings

  def available?
    borrowings.where(returned: false).empty?
  end
end

# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  has_many :borrowings
  has_many :books, through: :borrowings
end

# app/models/borrowing.rb
class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  before_create :set_due_date

  private

  def set_due_date
    self.due_date = 2.weeks.from_now.to_date
  end
end
```
## Routes Configuration

The routes are defined to handle CRUD operations and custom actions:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'books#index'
  resources :books, only: [:index, :show]
  post '/books/:id/borrow', to: 'borrowings#create', as: 'borrow_book'
  delete '/books/:id/return', to: 'borrowings#destroy', as: 'return_book'
  resources :users, only: [:show]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
# app/controllers/borrowings_controller.rb
class BorrowingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:id])
    if @book.available?
      @borrowing = current_user.borrowings.create!(book: @book)
      redirect_to book_path(@book), notice: 'Book borrowed successfully.'
    else
      redirect_to book_path(@book), alert: 'This book is already borrowed.'
    end
  end

  def destroy
    @borrowing = current_user.borrowings.find_by!(book_id: params[:id], returned: false)
    @borrowing.update!(returned: true)
    redirect_to user_path(current_user), notice: 'Book returned successfully.'
  end
end
```
git clone https://github.com/your-username/library-management-system.git
cd library-management-system
