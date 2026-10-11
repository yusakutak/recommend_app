class AddStatusToRelationships < ActiveRecord::Migration[8.0]
  def change
    add_column :relationships, :status, :string, default: "accepted", null: false
  end
end
