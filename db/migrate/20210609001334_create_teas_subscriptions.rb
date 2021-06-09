class CreateTeasSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :teas_subscriptions do |t|
      t.references :tea, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true

      t.timestamps
    end
  end
end
