class CreateRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
     add_index :relationships, :user_id
    add_index :relationships, :friend_id
    add_index :relationships, [:user_id, :friend_id], unique: true
  end
end
