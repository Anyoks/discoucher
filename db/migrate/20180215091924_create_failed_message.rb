class CreateFailedMessage < ActiveRecord::Migration[5.1]
  def change
    create_table :failed_messages, id: :integer do |t|
      t.string :message
      t.string :phone_number
    end
  end
end
