class AddCodeToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :code, :string
    add_index :categories, :code, unique: true
  end
end
