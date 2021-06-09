class ChangeFloatForPrice < ActiveRecord::Migration[6.0]
  def self.up
    change_table :subscriptions do |t|
      t.change :price, :float
    end
  end
  def self.down
    change_table :price do |t|
      t.change :price, :integer
    end
  end
end
