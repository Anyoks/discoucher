class CreateJoinTable < ActiveRecord::Migration[5.1]
  def change
  	create_join_table :vouchers, :tags, id: false do |t|
  	    t.uuid :voucher_id, index: true
  	    t.uuid :tag_id, index: true
	end

	# remove_column :tags, :voucher_id, :uuid
  end
end
