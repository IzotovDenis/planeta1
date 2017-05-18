class CreateItems < ActiveRecord::Migration[5.0]
  def change
    enable_extension "hstore"
    create_table :items do |t|
      t.string   "cid"
      t.string   "article"
      t.string   "title"
      t.string   "full_title"
      t.string   "group_cid"
      t.integer  "group_id"
      t.string   "image"
      t.hstore   "properties"
      t.text     "text"
      t.integer  "qty",              default: 0
      t.integer  "importsession_id"
      t.integer  "position"
      t.string   "brand"
      t.hstore   "label"
      t.string   "certificate"
      t.string   "cross", array: true
      t.jsonb    "bids",  default: {}, null: false
      t.timestamps
    end
  end
end