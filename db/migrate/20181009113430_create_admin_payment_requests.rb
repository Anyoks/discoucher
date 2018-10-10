class CreateAdminPaymentRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_requests, id: :uuid do |t|
      t.string :MerchantRequestID
      t.string :CheckoutRequestID
      t.string :ResponseCode
      t.string :ResponseDescription
      t.string :CustomerMessage

      t.uuid  :user_id, foreign_key: true
      t.timestamps
    end
  end
end
