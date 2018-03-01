class AddIndexToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_index :vouchers, :code,                unique: true
  end
end
