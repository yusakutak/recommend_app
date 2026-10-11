class AddShopIdToRestaurants < ActiveRecord::Migration[8.0]
  def change
    add_column :restaurants, :shop_id, :string
    add_index :restaurants, :shop_id, unique: true
  end
end
