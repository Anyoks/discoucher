json.extract! admin_payment_response, :id, :MerchantRequestID, :CheckoutRequestID, :ResultCode, :ResultDescription, :Amount, :MpesaReceiptNumber, :Balance, :TransactionDate, :PhoneNumber, :created_at, :updated_at
json.url admin_payment_response_url(admin_payment_response, format: :json)
