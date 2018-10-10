json.extract! admin_payment_request, :id, :MerchantRequestID, :CheckoutRequestID, :ResponseCode, :ResponseDescription, :CustomerMessage, :created_at, :updated_at
json.url admin_payment_request_url(admin_payment_request, format: :json)
