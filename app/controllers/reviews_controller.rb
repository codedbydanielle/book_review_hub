class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book
  before_action :set_review, only: [:destroy]

def create
  @review = @book.reviews.new(review_params)
  @review.user = current_user

  if @review.save
    redirect_to @book, notice: "Review was successfully added."
  else
    @reviews = @book.reviews.includes(:user).order(created_at: :desc)
    render "books/show", status: :unprocessable_entity
  end
end

  def destroy
    if @review.user == current_user
      @review.destroy
      redirect_to @book, notice: "Review was successfully deleted."
    else
      redirect_to @book, alert: "You can only delete your own reviews."
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end