class AddUniqToItems < ActiveRecord::Migration[5.1]
  def change
	add_index :items, :cid, :unique => true
  end
end
