# coding: utf-8
ThinkingSphinx::Index.define :item, :name => 'item_title', :with => :active_record do
  # fields
  join group
  where "disabled = 'f' OR disabled IS NULL"
  indexes "properties -> 'Полное наименование'", :as => :full_name, :sortable => true
  has created_at, updated_at, group_id, position
end