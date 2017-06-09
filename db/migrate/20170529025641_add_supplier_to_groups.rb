class AddSupplierToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :supplier_id, :integer, default: 0
  end
end
