class CreateFriendships < ActiveRecord::Migration[5.0]
  def change
    create_table :friendships do |t|
      t.integer :initiator_id, :responder_id
      t.boolean :accepted, default: false, null: false
      t.timestamps
    end
  end
end
