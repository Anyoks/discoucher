class Admin::UserController < Admin::ApplicationController
  def index
  	@users = User.all.order(created_at: :desc)

    # Bar chart
    @vists_data = overal_visits_by_month
    @options1 = {:height => "257px", :width => "514px"}

    # doughnut
    @data = establisments_visits
    @options = {:height => "257px", :width => "514px"}

    # least and most active users
    @most_active = most_active
    @least_active = least_active
  end

  def show
  	@user = User.find(params[:id])
    @user_visits = @user.visits #how many establishments did you visit?
    @data = user_activities @user

    @dates = date_activites @user

    @total = progress @user
    @so_far = @user.visits.count

    
    @options = {:height => "257px", :width => "514px"}
    @options1 = {:height => "257px", :width => "514px"}
  end

  def progress user

    user = user
    total = 0

    if user.register_books.count == 0
      return total
    else
      user.register_books.each do |b| 

        if b.book.vouchers.count != 0
         total_book_for_this_book = b.book.vouchers.count
         total = total + total_book_for_this_book
        end
      end
      
      return total
   end
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

  def establisments_visits
      base = User.select(:first_name).joins(:visits).select(:first_name)
      establishment_names = base.to_a.group_by(&:first_name).map {|label, data| label}
      establishment_vists_count = base.to_a.group_by(&:first_name).map {|label, data| data.count}

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

  def most_active
      most_and_least_active = get_most_least
      most_active_name = most_and_least_active[1].first.user.first_name   
      most_active_count = most_and_least_active[1].size
      array = []

      array << most_active_name << most_active_count
      return array      
    end

    def least_active
      least_active_name = get_most_least
      least_active_name = least_active_name[0].first.user.name
      least_active_count = least_active_name[0].size
      array = []

      array << least_active_name << least_active_count
      return array
    end

    def get_most_least
      most_and_least_active = Visit.select(:user_id).group_by(&:user_id).map {|name, data| data}.minmax
      return most_and_least_active
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
