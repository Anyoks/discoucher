class AddColumnToPaymentResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_responses, :book_code, :string, null: false, default: "test"
  end
end
