class Admin::PaymentResponsesController < ApplicationController
  before_action :set_admin_payment_response, only: [:show, :edit, :update, :destroy]

  # GET /admin/payment_responses
  # GET /admin/payment_responses.json
  def index
    @admin_payment_responses = PaymentResponse.all
  end

  # GET /admin/payment_responses/1
  # GET /admin/payment_responses/1.json
  def show
  end

  # GET /admin/payment_responses/new
  def new
    @admin_payment_response = PaymentResponse.new
  end

  # GET /admin/payment_responses/1/edit
  def edit
  end

  # POST /admin/payment_responses
  # POST /admin/payment_responses.json
  def create
    @admin_payment_response = PaymentResponse.new(admin_payment_response_params)

    respond_to do |format|
      if @admin_payment_response.save
        format.html { redirect_to @admin_payment_response, notice: 'Payment response was successfully created.' }
        format.json { render :show, status: :created, location: @admin_payment_response }
      else
        format.html { render :new }
        format.json { render json: @admin_payment_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/payment_responses/1
  # PATCH/PUT /admin/payment_responses/1.json
  def update
    respond_to do |format|
      if @admin_payment_response.update(admin_payment_response_params)
        format.html { redirect_to @admin_payment_response, notice: 'Payment response was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_payment_response }
      else
        format.html { render :edit }
        format.json { render json: @admin_payment_response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/payment_responses/1
  # DELETE /admin/payment_responses/1.json
  def destroy
    @admin_payment_response.destroy
    respond_to do |format|
      format.html { redirect_to admin_payment_responses_url, notice: 'Payment response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_payment_response
      @admin_payment_response = PaymentResponse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_payment_response_params
      params.require(:admin_payment_response).permit(:MerchantRequestID, :CheckoutRequestID, :ResultCode, :ResultDescription, :Amount, :MpesaReceiptNumber, :Balance, :TransactionDate, :PhoneNumber)
    end
end
