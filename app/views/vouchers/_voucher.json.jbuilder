json.extract! voucher, :id, :code, :description, :condition, :year, :created_at, :updated_at
json.url voucher_url(voucher, format: :json)
