class CreateAdminPaymentResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_responses, id: :uuid do |t|
      t.string :MerchantRequestID
      t.string :CheckoutRequestID
      t.string :ResultCode
      t.string :ResultDescription
      t.string :Amount
      t.string :MpesaReceiptNumber
      t.string :Balance
      t.datetime :TransactionDate
      t.string :PhoneNumber


      t.uuid  :payment_request_id, foreign_key: true

      t.timestamps
    end
  end
end
