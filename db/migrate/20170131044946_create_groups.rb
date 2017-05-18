class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string 'cid'
      t.string 'title'
      t.string 'parent_cid'
      t.string 'ancestry'
      t.integer 'position'
      t.string 'site_title'
      t.string 'sort_type'
      t.boolean 'disabled', default: false
      t.integer 'importsession_id'
      t.datetime 'last_new_item'
      t.integer 'items_count', default: 0
      t.timestamps
    end
  end
end
