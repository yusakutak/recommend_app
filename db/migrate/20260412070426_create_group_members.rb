class CreateGroupMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :group_members do |t|
      t.integer  :user_id,  null: false
      t.integer  :group_id, null: false
      t.datetime :joined_at

      t.timestamps
    end
  end
end
