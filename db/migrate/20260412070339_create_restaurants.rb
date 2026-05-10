class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
     t.string :name,            null: false
      t.integer :cuisine_type_id, null: false
      t.string  :hotpepper_id,    null: false
      t.string  :address
      t.float   :latitude
      t.float   :longitude
      t.string  :phone
      t.text    :description

      t.timestamps
    end
  end
end
