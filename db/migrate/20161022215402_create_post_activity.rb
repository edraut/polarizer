class CreatePostActivity < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute(<<-SQL)
      CREATE MATERIALIZED VIEW post_activities AS
        SELECT p.id as post_id,
        GREATEST(
          p.updated_at,
          MAX(c.updated_at)) as last_activity_time
        FROM posts p
        LEFT JOIN comments c
          ON c.post_id = p.id
        GROUP BY p.id
    SQL
    add_index :post_activities, :post_id, unique: true
  end

  def down
    ActiveRecord::Base.connection.execute(<<-SQL)
      DROP MATERIALIZED VIEW post_activities;
    SQL
  end
end
