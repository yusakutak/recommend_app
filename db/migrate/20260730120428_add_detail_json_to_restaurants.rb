class AddDetailJsonToRestaurants < ActiveRecord::Migration[8.0]
  def change
    add_column :restaurants, :detail_json, :text
  end
end
