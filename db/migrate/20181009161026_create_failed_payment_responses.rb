class CreateFailedPaymentResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :failed_payment_responses, id: :uuid do |t|
      t.string :MerchantRequestID
      t.string :CheckoutRequestID
      t.string :ResultCode
      t.string :ResultDescription

      t.uuid  :payment_request_id, foreign_key: true

      t.timestamps
    end
  end
end
