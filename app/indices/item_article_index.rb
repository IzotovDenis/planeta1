ThinkingSphinx::Index.define :item, :name => 'item_article', :with => :active_record do
  # fields
  join group
  where "disabled = 'f' OR disabled IS NULL"
  indexes article, :sortable => true
  has created_at, updated_at, group_id, position
end