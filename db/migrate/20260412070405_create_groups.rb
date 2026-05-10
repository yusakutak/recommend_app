class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.integer :creator_id, null: false

      t.timestamps
    end
  end
end
