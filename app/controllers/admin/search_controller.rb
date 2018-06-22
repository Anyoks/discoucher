class Admin::SearchController < Admin::ApplicationController
	def search
	if params[:q].nil?
		@results = []
	else
		evaluate_search_controller

	end
	end

	def evaluate_search_controller
	if params[:establishments] == ""
		search_establishments
	elsif params[:books] == ""
		search_books
	elsif params[:vouchers] == ""
		search_vouchers
	elsif params[:user] == ""
		search_users
	else
		# cannot find controller.
	end
	end
			
 

	def search_books
		elastic_query = {
			fields: [:code],
			order: { _score: :desc },
			page: params[:page],
			per_page: 15
		}
	 	@results = Book.search(params[:q], elastic_query)
	end

	def search_establishments
		elastic_query = {
			fields: [:name, :type, :location, :area, :phone],
			order: { _score: :desc },
			page: params[:page],
			per_page: 15
		}
		@results = Establishment.search(params[:q], elastic_query)
	end

	def search_vouchers
		elastic_query = {
			fields: [:code, :description, :condition, :establishment],
			order: { _score: :desc },
			page: params[:page],
			per_page: 15
		}
		@results = Voucher.search(params[:q], elastic_query)
	end

	def search_users
	elastic_query = {
		fields: [:first_name, :last_name, :email, :phone_number],
		order: { _score: :desc },
		page: params[:page],
		per_page: 15
	}

	@results = User.search(params[:q], elastic_query)

	end


end