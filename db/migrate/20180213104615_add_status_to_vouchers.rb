class AddStatusToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_column :vouchers, :redeem_status, :boolean, default: :false
    
  end
end
