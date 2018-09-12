class  Admin::TagsController < Admin::ApplicationController 
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /admin/tags
  # GET /admin/tags.json
  def index
     @tags =  Tag.all.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/tags/1
  # GET /admin/tags/1.json
  def show
  end

  # GET /admin/tags/new
  def new
     @tag =  Tag.new
  end

  # GET /admin/tags/1/edit
  def edit
  end

  # POST /admin/tags
  # POST /admin/tags.json
  def create
     @tag =  Tag.new(tag_params)

    respond_to do |format|
      if  @tag.save
        # check if some images have been uploaded.
        if params[:images]
          #===== The magic is here ;)
          params[:images].each { |image|
            @tag.image =  image          }
        end
        format.html { redirect_to  admin_tags_url(@tag), notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location:  @tag }
      else
        format.html { render :new }
        format.json { render json:  @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tags/1
  # PATCH/PUT /admin/tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to admin_tags_url(@tag), notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.json
  def destroy
     @tag.destroy
    respond_to do |format|
      format.html { redirect_to admin_tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
       @tag =  Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name, :voucher_id)
    end
end
