class Admin::EstablishmentTypesController < ApplicationController
  before_action :set_admin_establishment_type, only: [:show, :edit, :update, :destroy]

  # GET /admin/establishment_types
  # GET /admin/establishment_types.json
  def index
    @admin_establishment_types =  EstablishmentType.all.order('name ASC').paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/establishment_types/1
  # GET /admin/establishment_types/1.json
  def show
  end

  # GET /admin/establishment_types/new
  def new
    @admin_establishment_type =  EstablishmentType.new
  end

  # GET /admin/establishment_types/1/edit
  def edit
  end

  # POST /admin/establishment_types
  # POST /admin/establishment_types.json
  def create
    @admin_establishment_type =  EstablishmentType.new(admin_establishment_type_params)

    respond_to do |format|
      if @admin_establishment_type.save
        format.html { redirect_to admin_establishment_types_url(@admin_establishment_type), notice: 'Establishment type was successfully created.' }
        format.json { render :show, status: :created, location: @admin_establishment_type }
      else
        format.html { render :new }
        format.json { render json: @admin_establishment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/establishment_types/1
  # PATCH/PUT /admin/establishment_types/1.json
  def update
    respond_to do |format|
      if @admin_establishment_type.update(admin_establishment_type_params)
        format.html { redirect_to @admin_establishment_type, notice: 'Establishment type was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_establishment_type }
      else
        format.html { render :edit }
        format.json { render json: @admin_establishment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/establishment_types/1
  # DELETE /admin/establishment_types/1.json
  def destroy
    @admin_establishment_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_establishment_types_url, notice: 'Establishment type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_establishment_type
      @admin_establishment_type =  EstablishmentType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_establishment_type_params
      params.require(:establishment_type).permit(:name, :description)
    end
end
