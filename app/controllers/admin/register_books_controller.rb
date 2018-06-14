class Admin::RegisterBooksController < Admin::ApplicationController
  # skip_before_action :authenticate_admin!, only: [:new, :create], raise: false
  # before_filter :authenticate_user!, except: [:index]
  before_action :authenticate_admin!, except: [:new]
  before_action :set_register_book, only: [:show, :edit, :update, :destroy]

  layout false
  layout 'admin_lte_2', :except => :view, except: [:new, :create]
  # layout 'new'
  # layout :resolve_layout

  # GET /register_books
  # GET /register_books.json
  def index
    @register_books = RegisterBook.all.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /register_books/1
  # GET /register_books/1.json
  def show
  end

  # GET /register_books/new
  def new
    @register_book = RegisterBook.new
  end

  # GET /register_books/1/edit
  def edit
  end

  # POST /register_books
  # POST /register_books.json
  def create
    
    
    savedBook = RegisterBook.new(register_book_params)

    # check if the user exists

    # check if book exists and is not registered & create new reg book for existing user
    check = savedBook.find_book_by_code
    
    respond_to do |format|
      if  check.class.name != "FalseClass" #@register_book.save
        # find the user
        @register_book = check
        @user = @register_book.user
        # send an email asynchronously
        RegisterMailer.registration_email(@user).deliver_later

        format.html { redirect_to admin_register_book_path(@register_book), notice: 'Register book was successfully created.' }
        format.json { render :show, status: :created, location: @register_book }
      else
       
        format.html { render :new }
        format.json { render json: @register_book.errors, status: :unprocessable_entity }
        @register_book = RegisterBook.new(register_book_params)
      end
    end
  end

  # PATCH/PUT /register_books/1
  # PATCH/PUT /register_books/1.json
  def update
    respond_to do |format|
      if @register_book.update(register_book_params)
        format.html { redirect_to admin_register_book_path(@register_book), notice: 'Register book was successfully updated.' }
        format.json { render :show, status: :ok, location: @register_book }
      else
        format.html { render :edit }
        format.json { render json: @register_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /register_books/1
  # DELETE /register_books/1.json
  def destroy
    @register_book.destroy
    respond_to do |format|
      format.html { redirect_to admin_register_books_url, notice: 'Register book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_register_book
      @register_book = RegisterBook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def register_book_params
      params.require(:register_book).permit(:first_name, :last_name, :phone_number, :email, :book_code)
    end

    # def resolve_layout
    #   case action_name
    #     when "new", "create"
    #       "register_book/new"
    #     when "index"
    #       "admin_lte_2"
    #     else
    #       "application"
    #   end
    # end 
end
