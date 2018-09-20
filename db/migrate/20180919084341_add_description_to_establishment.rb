class AddDescriptionToEstablishment < ActiveRecord::Migration[5.1]
  def change
    add_column :establishments, :description, :text
    add_column :establishments, :working_hours, :string
    add_column :establishments, :email, :string
    add_column :establishments, :website, :string
    add_column :establishments, :social_media, :string
  end
end
