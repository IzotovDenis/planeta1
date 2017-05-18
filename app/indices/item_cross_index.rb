# coding: utf-8
ThinkingSphinx::Index.define :item, :name => 'item_cross', :with => :active_record do
  # fields
  join group
  where "disabled = 'f' OR disabled IS NULL"
  indexes "array_to_string(items.cross, ' ', '*')", :as => :cross
  has created_at, updated_at, group_id, position
end