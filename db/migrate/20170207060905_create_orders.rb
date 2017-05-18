class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.datetime :formed
      t.string :comment
      t.float :total,      default: 0.0
      t.jsonb :order_list, default: {}
      t.index :user_id, name: "index_orders_on_user_id", using: :btree
      t.timestamps
    end
  end
end
