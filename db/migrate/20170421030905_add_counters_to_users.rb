class AddCountersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :activities_count, :integer, default: 0
    add_column :users, :orders_count, :integer, default: 0
    add_column :users, :last_activity_at, :datetime
  end
end
