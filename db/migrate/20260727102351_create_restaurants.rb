class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.text :description

      t.timestamps
    end
  end
end
