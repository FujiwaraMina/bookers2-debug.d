class BooksController < ApplicationController

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    @book_tags = @book.tags
  end

  def index
    @book = Book.page(params[:page]).per(10)
    @book_new = Book.new
    @tag_list = Tag.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:name].split(',')
    if @book.save
       @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @tag_list = @book.tags.pluck(:name).join(',')
    if @book.user == current_user
      render "edit"
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    @tag_list = params[:book][:name].split(',')
    if @book.update(book_params)
      if @old_relations = BookTag.where(book_id: @book.id)
         @old_relations.each do |relation|
           relation.delete
         end
       @book.save_tag(@tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
      else
      render "edit"
      end
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @books= @tag.books.page(params[:page]).per(10)
    @keyword = params[:keyword]
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end
end
