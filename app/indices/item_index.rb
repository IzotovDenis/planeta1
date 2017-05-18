# coding: utf-8
ThinkingSphinx::Index.define :item, :with => :active_record do
  # fields
  join group
  where "disabled = 'f' OR disabled IS NULL"
  indexes "properties -> 'Полное наименование'", :as => :full_name, :sortable => true
  indexes "properties -> 'Код товара'", :as => :kod, :sortable => true
  indexes "replace(properties -> 'ОЕМ', '-', '')", :as => :oem, :sortable => true
  indexes "array_to_string(items.cross, ' ', '*')", :as => :cross
  indexes article, :sortable => true
  indexes brand
  has created_at, updated_at, group_id, position
end
