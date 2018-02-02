class CreateVouchers < ActiveRecord::Migration[5.1]
  def change
    create_table :vouchers, id: :uuid do |t|
      t.string :code
      t.text :description
      t.text :condition
      t.string :year

      t.timestamps
    end
  end
end
