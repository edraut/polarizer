class CreateChatParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_participants do |t|
      t.integer :user_id, :chatroom_id
      t.timestamps
    end
  end
end
