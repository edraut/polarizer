class PostActivity < ActiveRecord::Base
  self.table_name = 'post_activities'
  self.primary_key = 'post_id'

  belongs_to :post

  def self.refresh
    ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY post_activities")
  end
end