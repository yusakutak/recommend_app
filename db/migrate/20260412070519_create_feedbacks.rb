class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end
end
