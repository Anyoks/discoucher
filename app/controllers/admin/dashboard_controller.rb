class Admin::DashboardController < Admin::ApplicationController
  def index
  	establishments_data	
  	user_data
  	number_of_not_visited_establishments
  end

  

private
	def user_data
		@users = User.all.order(created_at: :desc)

		  # Bar chart
		@vists_data = overal_visits_by_month
		@options_user = {:height => "257px", :width => "514px"}

		# doughnut
		@data = establisments_visits "user"
		@options = {:height => "257px", :width => "514px"}

		# least and most active users
		@most_active_user = most_active "user"
		@least_active_user = least_active "user"
	end



	def establishments_data
		@establishments = Establishment.all
		@total_visits = Visit.all.count


		@data_establishments = establisments_visits "establishments"
		@options = {:height => "257px", :width => "514px"}

		# Bar chart
		@vists_data = overal_visits_by_month
		@options1 = {:height => "257px", :width => "514px"}

		# least and most active establishments
		@most_active_est = most_active "establishments"
		@least_active_est = least_active "establishments"
	end

	def establisments_visits type

		if type == "establishments"
	
	  		base = Establishment.select(:name).joins(:visits).select(:name)
	  	else
	  		base = User.select(:first_name).joins(:visits).select(:first_name)
	  	end


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
	  user_names = get_names(user_ids, user)

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

	def most_active type
	  most_and_least_active = get_most_least(type)

	  if most_and_least_active.any?
	  	most_active_name = get_active_name_by_class(most_and_least_active[1].first, type)
	  	most_active_count = most_and_least_active[1].size
	  else
	  	most_active_name = "none"
	    most_active_count = 0
	  end

	  
	  array = []

	  array << most_active_name << most_active_count
	  return array      
	end

	def get_active_name_by_class(arr_item, klass)
		# byebug
		if klass == "establishments"
			return arr_item.establishment.name  
		else
			return arr_item.user.first_name
		end
		
	end

	def least_active type
	  least_active_name = get_most_least(type)

	  if least_active_name.any?
	  	least_active_name = get_active_name_by_class(least_active_name[0].first, type)
	  	least_active_count = least_active_name[0].size
	  else
	  	least_active_name = "none"
	  	least_active_count = 0
	  end

	  
	  array = []

	  array << least_active_name << least_active_count
	  return array
	end

	def get_most_least type

		if type == "establishments"
	  		most_and_least_active = Visit.select(:establishment_id).group_by(&:establishment_id).map {|name, data| data}.minmax
	  	else
	  		most_and_least_active = Visit.select(:user_id).group_by(&:user_id).map {|name, data| data}.minmax
	  	end
		return most_and_least_active

	end

	def get_names(array, klass)
		it = get_class klass
	  names = []
	  array.each do |est|
	    user_name = it.find(est).name
	    names << user_name
	  end
	  return names  
	end

	def number_of_not_visited_establishments
		@not_visited = Visit.not_visited_establishments	
		return @not_visited
	end

	def get_class klass

		if klass == "establishments"
			return "Establishment".constantize
		else
			return "User".constantize
		end
		
	end
end
