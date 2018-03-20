class UserController < ApplicationController
  def index
  	@users = User.all.order(created_at: :desc)
  end

  def show
  	@user = User.find(params[:id])
    @user_visits = @user.visits #how many establishments did you visit?
    @data = user_activities @user

    @dates = date_activites @user

    
    @options = {:height => "257px", :width => "514px"}
    @options1 = {:height => "257px", :width => "514px"}
  end

  # def make_moderator
  #   @user = User.find(params[:user_id])
  #   @user.make_moderator
  #   respond_to do |format|
  #     format.html { redirect_to user_index_path, notice:  " #{@user.first_name} is now a Moderator." }
  #     format.json { head :no_content }
  #   end
  # end
  # def make_normal_user
  #   @user = User.find(params[:user_id])
  #   @user.make_normal_user
  #   respond_to do |format|
  #     format.html { redirect_to user_index_path, notice:  " #{@user.first_name} is now a Normal User." }
  #     format.json { head :no_content }
  #   end
  # end

  # Most active
  def user_activities user
    # put a limit to to 10 active users
    base = user.visits.select(:establishment_id).to_a.group_by(&:establishment_id)
    establishment_ids = base.map {|name, data| name}
    establishment_names = get_names establishment_ids
    establishment_visit_count = base.map {|name, data| data.count}

    colour = []
    establishment_visit_count.size.times { |c| colour <<"#%06x" % (rand * 0xffffff) }

    @establishment_vistis_by_name = {
      labels: establishment_names,
      datasets: [
        {
           # label: "My First dataset",
           # pointStrokeColor: "#FFA500",
           # fillColor: "rgba(255,165,0,0.5)",
           # pointColor: "rgba(255,165,0,1)",
           # strokeColor: "rgba(255,165,0,1)",
           data: establishment_visit_count,
           backgroundColor: colour,
           hoverBackgroundColor: "#FFA500"

        }
      ]
    }
    # Customer visits per establishments
    return @establishment_vistis_by_name
  end

  def date_activites user

    # user.visits.group_by_month(:created_at).count

    base = user.visits.group_by_month(:created_at).count#Visit.select(:establishment_id, :created_at).to_a.group_by_month(&:created_at)

    months_count = base.map {|name, data| data}
    colour = []
    months_count.size.times { |c| colour <<"#%06x" % (rand * 0xffffff) }

    @visits_by_month = {
      labels: base.to_a.map {|label, data| label.strftime("%B")},
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

  # least active user
  def least_active_user
    # least active, visits less than 5 but greater than 0
    
    v =Visit.select(:user_id).group_by(&:user_id)
    count = v.map { |name, data|  data.count }

  end

  # none active users
  
  def none_active_users
    # vistis == 0
    
    
  end

  def get_names array
    names = []
    array.each do |est|
      est_name = Establishment.find(est).name
      names << est_name
    end
    return names  
  end


  def destroy
  	@user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to user_index_path, notice:  " #{@user.first_name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end
end
