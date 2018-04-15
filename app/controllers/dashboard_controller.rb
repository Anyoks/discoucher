class DashboardController < ApplicationController
  def index
  	establishments_data	


  end

private
	def establishments_data
		@establishments = Establishment.all
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
	  most_active_name = most_and_least_active[1].first.establishment.name   
	  most_active_count = most_and_least_active[1].size
	  array = []

	  array << most_active_name << most_active_count
	  return array      
	end

	def least_active
	  least_active_name = get_most_least
	  least_active_name = least_active_name[0].first.establishment.name
	  least_active_count = least_active_name[0].size
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
end
