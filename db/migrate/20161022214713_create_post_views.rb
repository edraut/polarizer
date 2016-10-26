class CreatePostViews < ActiveRecord::Migration[5.0]
  def change
    create_table :post_views do |t|
      t.integer :user_id, :post_id
      t.timestamps
    end
  end
end
