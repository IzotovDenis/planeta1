class AddUniqToGroups < ActiveRecord::Migration[5.1]
  def change
  add_index :groups, :cid, :unique => true
  end
end
