class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  def my_books
  @books = current_user.books.order(created_at: :desc)
  end

  # GET /books/1 or /books/1.json
  def show
    @review = Review.new
    @reviews = @book.reviews.includes(:user).order(created_at: :desc)
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = current_user.books.new(book_params)

    respond_to do |format|
      if @book.save
        attach_open_library_cover

        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        attach_open_library_cover

        format.html { redirect_to @book, notice: "Book was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, notice: "Book was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def attach_open_library_cover
    return if params[:book][:open_library_cover_url].blank?
    return if @book.cover_image.attached?

    require "open-uri"

    image_url = params[:book][:open_library_cover_url]
    downloaded_image = URI.open(image_url)

    @book.cover_image.attach(
      io: downloaded_image,
      filename: "open-library-cover.jpg",
      content_type: "image/jpeg"
    )
  end

    def authorize_user!
      redirect_to books_path, alert: "Not authorized." unless @book.user == current_user
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_params
params.require(:book).permit(
  :title,
  :author,
  :genre,
  :description,
  :isbn,
  :cover_image,
  :open_library_cover_url
)    
  end
end
