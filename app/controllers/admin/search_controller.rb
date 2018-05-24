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
  	 @results = Book.search params[:q]
  end

  def search_establishments
  	@results = Establishment.search params[:q]
  end

  def search_vouchers
  	@results = Voucher.search params[:q]
  end

  def search_users
  	@results = User.search params[:q]
  end
end