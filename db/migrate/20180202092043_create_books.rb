class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books, id: :uuid do |t|
      t.string :code
      t.string :year

      t.timestamps
    end
  end
end
