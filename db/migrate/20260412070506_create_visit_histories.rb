class CreateVisitHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :visit_histories do |t|
    t.integer :user_id,       null: false
      t.integer  :restaurant_id, null: false
      t.datetime :visited_at,    null: false
      t.timestamps
    end
  end
end
