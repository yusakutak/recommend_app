class DropMessages < ActiveRecord::Migration[8.0]
  def change
    drop_table :messages do |t|
      t.integer "group_id", null: false
      t.integer "user_id", null: false
      t.text "content"

      t.timestamps
      t.index ["group_id"], name: "index_messages_on_group_id"
      t.index ["user_id"], name: "index_messages_on_user_id"
    end
  end
end
