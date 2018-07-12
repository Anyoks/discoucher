class Admin::PicturesController < Admin::ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /admin/pictures
  # GET /admin/pictures.json
  def index
    @establishment = Establishment.find(params[:establishment_id])
    @pictures = @establishment.pictures.all
  end

  # GET /admin/pictures/1
  # GET /admin/pictures/1.json
  def show
  end

  # GET /admin/pictures/new
  def new
    @establishment = Establishment.find(params[:establishment_id])
    @picture = @establishment.pictures.new
  end

  # GET /admin/pictures/1/edit
  def edit
  end

  # POST /admin/pictures
  # POST /admin/pictures.json
  def create
    @establishment = Establishment.find(params[:establishment_id])
    @picture = @establishment.pictures.new
    # @picture = Picture.new(picture_params)
    # @picture = @establishment.pictures.new

    respond_to do |format|
      if params[:images]

        params[:images].each { |image|
          @picture = @establishment.pictures.create(image: image)
        }

        format.html { redirect_to admin_establishment_pictures_path(@establishment), notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @establishment }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/pictures/1
  # PATCH/PUT /admin/pictures/1.json
  def update
    @establishment = Establishment.find(params[:establishment_id])
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to admin_establishment_pictures_path(@establishment), notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @establishment }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/pictures/1
  # DELETE /admin/pictures/1.json
  def destroy
    @establishment = Establishment.find(params[:establishment_id])
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to  admin_establishment_pictures_path(@establishment), notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:picture, :description, {images: []})
    end
end
