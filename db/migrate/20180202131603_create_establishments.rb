class CreateEstablishments < ActiveRecord::Migration[5.1]
  def change
    create_table :establishments, id: :uuid do |t|
      t.string :name
      t.string :type
      t.string :location
      t.string :phone
      t.string :address
      t.attachment :logo

      t.timestamps
    end
  end
end
