class Admin::TagsVouchersController < ApplicationController
  before_action :set_admin_tags_voucher, only: [:show, :edit, :update, :destroy]

  # GET /admin/tags_vouchers
  # GET /admin/tags_vouchers.json
   def index
      @voucher = Voucher.find(params[:voucher_id])
      @tags = @voucher.tags.paginate(:page => params[:page], :per_page => 20)
  end

  # def show_voucher_tags
  #   @voucher = Voucher.find(params[:voucher_id])
  #   @tags = @voucher.tags.paginate(:page => params[:page], :per_page => 20)
  # end

  # GET /admin/tags/1
  # GET /admin/tags/1.json
  def show
    
  end

  # GET /admin/tags/new
  def new
    @tag = Tag.new
    @voucher = Voucher.find(params[:voucher_id])
  end

  # GET /admin/tags/1/edit
  def edit
  end

  # POST /admin/tags
  # POST /admin/tags.json
  def create
    
    # if params[:voucher_ids]
    # byebug
      @voucher = Voucher.find(params[:tag][:voucher_ids])
    # else
      @tag =  Tag.new(tag_params)
    # end
     
    respond_to do |format|
      if  @tag.save
        
        # check if some images have been uploaded.
        if params[:images]
          #===== The magic is here ;)
          params[:images].each { |image|
            @tag.tagpics.create(image: image)
          }
        end

        @voucher.tags << @tag # populate the join table for the many to many relationship.

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
    @voucher = Voucher.find(params[:voucher_id])

    @voucher.tags.delete(@tag)
     # @tag.destroy
    respond_to do |format|
      format.html { redirect_to admin_voucher_tags_vouchers_url, notice: 'Voucher was successfully untagged.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_tags_voucher
       @tag =  Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name,{voucher_ids: []} ,{images: []})
    end
end
