class Admin::TagpicsController < ApplicationController
  before_action :set_admin_tagpic, only: [:show, :edit, :update, :destroy]

  # GET /admin/tagpics
  # GET /admin/tagpics.json
  def index
    
    @tag = Tag.find(params[:tag_id])
    @tagpics = @tag.tagpics.all
  end

  # GET /admin/tagpics/1
  # GET /admin/tagpics/1.json
  def show
  end

  # GET /admin/tagpics/new
  def new
    @tag = Tag.find(params[:tag_id])
    @tagpic = @tag.tagpics.new
  end

  # GET /admin/tagpics/1/edit
  def edit
  end

  # POST /admin/tagpics
  # POST /admin/tagpics.json
  def create
    # @tagpic = Tagpic.new(admin_tagpic_params)

    @tag = Tag.find(params[:tag_id])
    @tagpic = @tag.tagpics.new

    respond_to do |format|
      if params[:images]

        params[:images].each { |image|
          @tagpic = @tag.tagpics.create(image: image)
        }

        format.html { redirect_to admin_tag_tagpics_path(@tag), notice: 'Tagpic was successfully created.' }
        format.json { render :show, status: :created, location: @tagpic }
      else
        format.html { render :new }
        format.json { render json: @tagpic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tagpics/1
  # PATCH/PUT /admin/tagpics/1.json
  def update
    @tag = Tag.find(params[:tag_id])
    respond_to do |format|
      if @tagpic.update(admin_tagpic_params)
        format.html { redirect_to admin_tag_tagpics_path(@tag), notice: 'Tagpic was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tagpic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tagpics/1
  # DELETE /admin/tagpics/1.json
  def destroy
    @tag = Tag.find(params[:tag_id])
    @tagpic.destroy
    respond_to do |format|
      format.html { redirect_to admin_tag_tagpics_path(@tag), notice: 'Tagpic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_tagpic
      @tagpic = Tagpic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_tagpic_params
      params.fetch(:tagpic, {})
      params.require(:tagpic).permit({images: []})
    end
end
