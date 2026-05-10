class CreateUserPreferences < ActiveRecord::Migration[8.0]
  def change
    create_table :user_preferences do |t|
      t.integer  :user_id,             null: false
      t.integer  :cuisine_type_id,     null: false
      t.integer  :score,               null: false, default: 0
      t.boolean  :auto_update_enabled, null: false, default: false
      t.datetime :last_updated_at

      t.timestamps
    end
  end
end
