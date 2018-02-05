class AddEstablishmentIdToVouchers < ActiveRecord::Migration[5.1]
  def change

  	if Establishment.first.present?
  		establishment = Establishment.first
  	else
  		establishment = Establishment.new(name: 'testing', location: 'watamu', phone: '07222123213', address: '123')
  	end

    add_column :vouchers, :establishment_id, :uuid, default: establishment.id
    add_index :vouchers, :establishment_id
  end
end
