class AddMenuColumnsToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :menu_columns, :integer
  end
end
