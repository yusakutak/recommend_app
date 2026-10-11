class ChangeDefaultStatusOnRelationships < ActiveRecord::Migration[8.0]
  def change
    change_column_default :relationships, :status, from: "accepted", to: "pending"
  end
end
