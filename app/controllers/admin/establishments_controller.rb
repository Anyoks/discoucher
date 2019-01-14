class Admin::EstablishmentsController < Admin::ApplicationController
  before_action :set_establishment, only: [:show, :edit, :update, :destroy]

  # GET /establishments
  # GET /establishments.json
  def index

    if params[:category]
      @establishments = Establishment.where(:establishment_type => params[:category]).order('name ASC').paginate(:page => params[:page], :per_page => 20)
      @category = @establishments.first.type.name
      # flash[:notice] = "There are <b>#{@category}</b> in this category".html_safe
    else
      @establishments = Establishment.all.order('name ASC').paginate(:page => params[:page], :per_page => 20)
    end
    
    @total_visits = Visit.all.count

  
    @data = establisments_visits
    @options = {:height => "257px", :width => "514px"}

    # Bar chart
    @vists_data = overal_visits_by_month
    @options1 = {:height => "257px", :width => "514px"}

    # least and most active establishments
    @most_active = most_active
    @least_active = least_active
  end

  # GET /establishments/1
  # GET /establishments/1.json
  def show
    @establishment = Establishment.find(params[:id])
    @establishment_visits = @establishment.visits #how many establishments did you visit?
    @data = establishment_activities @establishment

    @dates = date_activities @establishment

    
    @options = {:height => "257px", :width => "514px"}
    @options1 = {:height => "257px", :width => "514px"}
  end

  # GET /establishments/new
  def new
    @establishment = Establishment.new
  end

  # GET /establishments/1/edit
  def edit
  end

  # POST /establishments
  # POST /establishments.json
  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.books << Book.all # not efficient code. later add a worker to do this
    respond_to do |format|
      if @establishment.save
        # check if some images have been uploaded.
        if params[:images]
          #===== The magic is here ;)
          params[:images].each { |image|
            @establishment.pictures.create(image: image)
          }
        end

        format.html { redirect_to admin_establishment_url(@establishment), notice: 'Establishment was successfully created.' }
        format.json { render :show, status: :created, location: @establishment }
      else
        format.html { render :new }
        format.json { render json: @establishment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /establishments/1
  # PATCH/PUT /establishments/1.json
  def update
    respond_to do |format|
      if @establishment.update(establishment_params)

        if params[:images]
          #===== The magic is here ;)
          params[:images].each { |image|
            @establishment.pictures.create(image: image)
          }
        end
        format.html { redirect_to admin_establishment_url(@establishment), notice: 'Establishment was successfully updated.' }
        format.json { render :show, status: :ok, location: @establishment }
      else
        format.html { render :edit }
        format.json { render json: @establishment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /establishments/1
  # DELETE /establishments/1.json
  def destroy
    @establishment.destroy
    # remove attatchment and delete the folders
    @establishment.logo.destroy 
    @establishment.logo.clear
    respond_to do |format|
      format.html { redirect_to admin_establishments_path, notice: 'Establishment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def editpic
     respond_to do |format|
      if @establishment.update(establishment_params)

        if params[:images]
          #===== The magic is here ;)
          params[:images].each { |image|
            @establishment.pictures.create(image: image)
          }
        end
        format.html { redirect_to admin_establishment_url(@establishment), notice: 'Establishment was successfully updated.' }
        format.json { render :show, status: :ok, location: @establishment }
      else
        format.html { render :edit }
        format.json { render json: @establishment.errors, status: :unprocessable_entity }
      end
    end
  end

  def showpic
    @establishment = Establishment.find(params[:id])
  end

  # def is_this_one_checked
  #   byebug
  #   @establishment = Establishment.find(params[:id])
  #   # @establishment.details.where(book_id: )

  # end

  private

    def establisments_visits
      base = Establishment.select(:name).joins(:visits).select(:name)
      establishment_names = base.to_a.group_by(&:name).map {|label, data| label}
      establishment_vists_count = base.to_a.group_by(&:name).map {|label, data| data.count}

      colour = []
      establishment_vists_count.size.times { |c| colour <<"#%06x" % (rand * 0xffffff) }

      @visits_by_month = {
        labels: establishment_names,
        datasets: [
          {
             # label: "My First dataset",
             # pointStrokeColor: "#FFA500",
             # fillColor: "rgba(255,165,0,0.5)",
             # pointColor: "rgba(255,165,0,1)",
             # strokeColor: "rgba(255,165,0,1)",
             data: establishment_vists_count,#array_of_data_four,
             backgroundColor: colour,
             hoverBackgroundColor: "#FFA500"

          }
        ]
      }
      
    end

    def overal_visits_by_month
      base = Visit.group_by_month(:created_at).count

      months = base.map {|label, data| label.strftime("%B")}
      establishment_vists_count = base.map {|label, data| data}

      colour = []
      establishment_vists_count.size.times { |c| colour <<"#%06x" % (rand * 0xffffff) }

      @visits_by_month = {
        labels: months,
        datasets: [
          {
             # label: "My First dataset",
             # pointStrokeColor: "#FFA500",
             # fillColor: "rgba(255,165,0,0.5)",
             # pointColor: "rgba(255,165,0,1)",
             # strokeColor: "rgba(255,165,0,1)",
             data: establishment_vists_count,#array_of_data_four,
             backgroundColor: colour,
             hoverBackgroundColor: "#FFA500"

          }
        ]
      }
      
    end

    def establishment_activities establishment
      base = establishment.visits.group_by_month(:created_at).count#Visit.select(:establishment_id, :created_at).to_a.group_by_month(&:created_at)

      months = base.to_a.map {|label, data| label.strftime("%B")}
      months_count = base.map {|name, data| data}
      colour = []
      months_count.size.times { |c| colour <<"#%06x" % (rand * 0xffffff) }

      @visits_by_month = {
        labels: months,
        datasets: [
          {
             # label: "My First dataset",
             # pointStrokeColor: "#FFA500",
             # fillColor: "rgba(255,165,0,0.5)",
             # pointColor: "rgba(255,165,0,1)",
             # strokeColor: "rgba(255,165,0,1)",
             data: months_count,#array_of_data_four,
             backgroundColor: colour,
             hoverBackgroundColor: "#FFA500"

          }
        ]
      }
      return @visits_by_month
    end

    def date_activities establishment
      base = establishment.visits.group_by(&:user_id)
      visit_per_user_count = base.map {|name, data| data.count}
      
      user_ids = base.map {|name, data| name}
      user_names = get_names user_ids

      colour = []
      visit_per_user_count.size.times { |c| colour <<"#%06x" % (rand * 0xffffff) }

      @user_vistis_by_name = {
        labels: user_names,
        datasets: [
          {
             # label: "My First dataset",
             # pointStrokeColor: "#FFA500",
             # fillColor: "rgba(255,165,0,0.5)",
             # pointColor: "rgba(255,165,0,1)",
             # strokeColor: "rgba(255,165,0,1)",
             data: visit_per_user_count,
             backgroundColor: colour,
             hoverBackgroundColor: "#FFA500"

          }
        ]
      }
      # Customer visits per establishments
      return @user_vistis_by_name
    end

    def most_active
      most_and_least_active = get_most_least

      if most_and_least_active.any?
        most_active_name = most_and_least_active[1].first.establishment.name   
        most_active_count = most_and_least_active[1].size
      else
        most_active_name = "none"
        most_active_count = 0
      end

      array = []

      array << most_active_name << most_active_count
      return array      
    end

    def least_active
      least_active_name = get_most_least

      if least_active_name.any?
        least_active_name = least_active_name[0].first.establishment.name
        least_active_count = least_active_name[0].size
      else
        least_active_name = "none"
        least_active_count = 0
      end
      # least_active_name = least_active_name[0].first.establishment.name
      # least_active_count = least_active_name[0].size
      array = []

      array << least_active_name << least_active_count
      return array
    end

    def get_most_least
      most_and_least_active = Visit.select(:establishment_id).group_by(&:establishment_id).map {|name, data| data}.minmax
      return most_and_least_active
    end

    def get_names array
      names = []
      array.each do |est|
        user_name = User.find(est).first_name
        names << user_name
      end
      return names  
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_establishment
      @establishment = Establishment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def establishment_params
      params.require(:establishment).permit(:name, :type, :location, :phone, :address,:establishment_type_id, :logo, {book_ids: []}, {images: []})
    end
end
