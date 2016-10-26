class CreateChatMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_messages do |t|
      t.integer :user_id, :chatroom_id
      t.text :message
      t.timestamps
    end
  end
end
