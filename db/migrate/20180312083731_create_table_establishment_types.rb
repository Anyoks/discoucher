class CreateTableEstablishmentTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :establishment_types, id: :integer do |t|
      t.string :name
      t.text :description
    end
    add_column :establishments, :establishment_types_id, :integer
    add_index :establishments, :establishment_types_id   
  end
end
