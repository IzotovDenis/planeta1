class AddSupplierToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :supplier_id, :integer, default: 0

  end
end
