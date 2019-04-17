class AddAvailableToEstablishmentType < ActiveRecord::Migration[5.1]
  def change
    add_column :establishment_types, :available, :boolean, null: false, default: false
  end
end
