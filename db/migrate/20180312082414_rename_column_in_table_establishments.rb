class RenameColumnInTableEstablishments < ActiveRecord::Migration[5.1]
  def change
  	rename_column :establishments, :type, :area
  end
end
