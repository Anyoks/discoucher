class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all.paginate(:page => params[:page], :per_page => 20)
    # lables = FailedRedemption.group_by_month(:created_at).count
    # 
    # Establishment Visits By Location
    labels =  Establishment.select(:location).joins(:visits).select(:location)
    array_of_data_one = labels.to_a.group_by(&:location).map {|label, data| data.count}
    colour = []
    array_of_data_one.size.times { |c| colour <<"#%06x" % (rand * 0xffffff) }

    # Establishment Visits By name
    labels2 =  Establishment.select(:name).joins(:visits).select(:name)
    array_of_data_two = labels2.to_a.group_by(&:name).map {|name, data| data.count}
    colour2 = []
    array_of_data_two.size.times { |c| colour2 <<"#%06x" % (rand * 0xffffff) }

    @data = {
      labels: labels.to_a.group_by(&:location).map {|label, data| label},
      datasets: [
        {
           # label: "My First dataset",
           # pointStrokeColor: "#FFA500",
           # fillColor: "rgba(255,165,0,0.5)",
           # pointColor: "rgba(255,165,0,1)",
           # strokeColor: "rgba(255,165,0,1)",
           data: array_of_data_one,
           backgroundColor: colour,
           hoverBackgroundColor: "#FFA500"

        }
      ]
    }
    @establishment_vistis_by_name = {
      labels: labels2.to_a.group_by(&:name).map {|name, data| name},
      datasets: [
        {
           # label: "My First dataset",
           # pointStrokeColor: "#FFA500",
           # fillColor: "rgba(255,165,0,0.5)",
           # pointColor: "rgba(255,165,0,1)",
           # strokeColor: "rgba(255,165,0,1)",
           data: array_of_data_two,
           backgroundColor: colour2,
           hoverBackgroundColor: "#FFA500"

        }
      ]
    }

    # Books Registered this week
    labels3 = RegisterBook.group_by_day(:created_at).count

    @options1 = {:height => "257px", :width => "514px"}
    @options2 = {:height => "257px", :width => "514px"}
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  def registration
    @book = Book.find(params[:id])
  end
  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:code, :year)
    end
end
