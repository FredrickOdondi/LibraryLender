Below is the improved **Markdown** version of your project description, formatted with proper Markdown syntax and including code snippets:

---

```markdown
# Library Management System

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

### 2. **Routes Configuration**
The routes are defined to handle CRUD operations and custom actions like borrowing and returning books:

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
```

### 3. **Controller Actions**
The `BorrowingsController` handles borrowing and returning logic:

```ruby
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

### 4. **View Example**
The book index page displays all available books and includes a "Borrow" button if the book is available:

```erb
<!-- app/views/books/index.html.erb -->
<h1>Available Books</h1>
<ul>
  <% @books.each do |book| %>
    <li>
      <%= book.title %> by <%= book.author %> (<%= book.isbn %>)
      <% if book.available? %>
        <%= link_to 'Borrow', borrow_book_path(book), method: :post, class: 'button' %>
      <% else %>
        <button class="button" disabled>Already Borrowed</button>
      <% end %>
    </li>
  <% end %>
</ul>
```

---

## My Experience

Developing this project was a rewarding experience that deepened my understanding of Ruby on Rails. Here are some key takeaways:

1. **Rails Conventions and Structure:**
   - The MVC architecture in Rails is intuitive and well-organized. Models handle data logic, controllers manage actions, and views render templates.
   - The convention-over-configuration approach significantly reduced setup time, allowing me to focus on building features.

2. **Active Record Associations:**
   - Understanding how models interact via associations (`has_many`, `belongs_to`) was crucial for implementing borrowing and returning logic.

3. **Routes, Controllers, and Views:**
   - Setting up RESTful routes and defining controller actions streamlined the development process.
   - Using Rails helpers like `link_to` and `form_with` made it easy to create interactive views.

4. **Authentication with Devise:**
   - Integrating Devise simplified user management, enabling secure authentication without writing extensive code.

5. **Testing and Debugging:**
   - Rails' robust error reporting and logging helped identify and resolve issues quickly.
   - Writing tests for models, controllers, and views ensured high test coverage and reliability.

6. **Gems and Tools:**
   - Gems like Devise, Simple Form, and Bootstrap enhanced productivity and improved the application's functionality and appearance.

---

## Installation

To set up the project locally, follow these steps:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/library-management-system.git
   cd library-management-system
   ```

2. **Install Dependencies:**
   ```bash
   bundle install
   ```

3. **Set Up the Database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed # Optional: Seeds sample data
   ```

4. **Start the Server:**
   ```bash
   rails server
   ```

5. **Access the Application:**
   Open your browser and navigate to `http://localhost:3000`.

---

## Conclusion

This project was an excellent introduction to Ruby on Rails, showcasing its power and simplicity. By building a Library Management System, I gained hands-on experience with core Rails concepts, including models, controllers, views, and authentication. The framework's conventions and tools enabled me to develop a functional application efficiently, paving the way for more complex projects in the future.
```

