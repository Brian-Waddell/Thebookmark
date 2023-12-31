class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @q = Book.ransack(params[:q])
    @books = authorize @q.result(distinct: true)

    if params[:q] && params[:q][:genre_cont].present?
      excluded_word = 'nonfiction'
      @books = @books.where.not(Book.arel_table[:genre].matches("%#{excluded_word}%"))
    end

    @breadcrumbs = [
      { content: "Books", href: books_path }
    ]
  end

  def show
    @breadcrumbs = [
      { content: "book", href: books_path },
      { content: @book.to_s, href: book_path(@book) }
    ]

    @q = Comment.ransack(params[:q])
    @results = @q.result.includes(:user_id, :commentable_id, :book_id)
  end

  def new
    @breadcrumbs = [
      { content: "book", href: books_path },
      { content: "New" }
    ]

    @book = Book.new
    @book.user_id = current_user.id
    authorize @book
  end

  def edit
    @breadcrumbs = [
      { content: "book", href: books_path },
      { content: @book.to_s, href: book_path(@book) },
      { content: "Edit" }
    ]
  end

  def create
    @book = current_user.books.new(book_params)
    authorize @book

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @book

    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @book
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = authorize Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :summary, :genre, :publish_date, :photo)
  end
end
