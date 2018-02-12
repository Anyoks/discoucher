class CreateSms < ActiveRecord::Migration[5.1]
  def change
    create_table :sms, id: :uuid do |t|
      t.string :message
      t.string :voucher_code
      t.string :book_code

      t.timestamps
    end
  end
end
