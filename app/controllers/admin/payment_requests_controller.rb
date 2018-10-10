class Admin::PaymentRequestsController < ApplicationController
  before_action :set_admin_payment_request, only: [:show, :edit, :update, :destroy]

  # GET /admin/payment_requests
  # GET /admin/payment_requests.json
  def index
    @admin_payment_requests = PaymentRequest.all
  end

  # GET /admin/payment_requests/1
  # GET /admin/payment_requests/1.json
  def show
  end

  # GET /admin/payment_requests/new
  def new
    @admin_payment_request = PaymentRequest.new
  end

  # GET /admin/payment_requests/1/edit
  def edit
  end

  # POST /admin/payment_requests
  # POST /admin/payment_requests.json
  def create
    @admin_payment_request = PaymentRequest.new(admin_payment_request_params)

    respond_to do |format|
      if @admin_payment_request.save
        format.html { redirect_to @admin_payment_request, notice: 'Payment request was successfully created.' }
        format.json { render :show, status: :created, location: @admin_payment_request }
      else
        format.html { render :new }
        format.json { render json: @admin_payment_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/payment_requests/1
  # PATCH/PUT /admin/payment_requests/1.json
  def update
    respond_to do |format|
      if @admin_payment_request.update(admin_payment_request_params)
        format.html { redirect_to @admin_payment_request, notice: 'Payment request was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_payment_request }
      else
        format.html { render :edit }
        format.json { render json: @admin_payment_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/payment_requests/1
  # DELETE /admin/payment_requests/1.json
  def destroy
    @admin_payment_request.destroy
    respond_to do |format|
      format.html { redirect_to admin_payment_requests_url, notice: 'Payment request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_payment_request
      @admin_payment_request = PaymentRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_payment_request_params
      params.require(:admin_payment_request).permit(:MerchantRequestID, :CheckoutRequestID, :ResponseCode, :ResponseDescription, :CustomerMessage)
    end
end
