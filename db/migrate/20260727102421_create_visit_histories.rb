class CreateVisitHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :visit_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.date :visited_on

      t.timestamps
    end
  end
end
