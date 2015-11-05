class AddedPostsTable < ActiveRecord::Migration
  def change

  	create_table :posts do |t|
      t.string :body, limit: 150
      t.integer :user_id

      t.timestamps null: false
  	end
  end
end
