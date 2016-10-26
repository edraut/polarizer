class CreateChatrooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chatrooms do |t|
      t.string :title
      t.integer :friendship_id
      t.timestamps
    end
  end
end
