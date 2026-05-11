class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id,       null: false
      t.integer :restaurant_id, null: false
      t.integer :visit_history_id, null: false
      t.integer :rating,        null: false
      t.text    :comment

      t.timestamps
    end
  end
end
