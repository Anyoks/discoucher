class AddStatusAndPhoneToSms < ActiveRecord::Migration[5.1]
  def change
    add_column :sms, :status, :boolean
    add_column :sms, :phone_number, :string
  end
end
