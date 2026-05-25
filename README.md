# 📖 Book Review Hub

A web application where readers can discover books, share reviews, and connect over great reads.

## Features

- Browse and search books
- Add books manually or auto-fill details using an ISBN lookup (powered by Open Library)
- Upload book covers or fetch them automatically via Open Library
- Leave star ratings and written reviews
- User authentication (sign up, log in, log out)
- Users can only edit or delete their own books and reviews

## Tech Stack

- Ruby on Rails 8
- PostgreSQL
- Tailwind CSS
- Devise (authentication)
- Active Storage (cover image uploads)
- Open Library API (book metadata + covers)

## Setup

1. Clone the repository
   git clone <https://github.com/codedbydanielle/book_review_hub.git>
   cd book_review_hub

2. Install dependencies
   bundle install

3. Set up the database
   rails db:create db:migrate

4. Start the server
   bin/dev

5. Visit http://localhost:3000