class Group < ApplicationRecord
    has_ancestry
    has_many :items
    scope :with_new_items, -> { joins(:items).select('MAX(items.created_at) AS item_created_at, groups.*').group('groups.id').order("item_created_at ASC") }
	  scope :able, ->{ where(disabled: [false,nil]).order('title') }
    scope :disableded, -> {where(disabled: true)}

  def self.arrange_as_array(options={}, hash=nil)                                                                                                                                                            
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.empty?
    end
    arr
  end

  def self.array_for_select
    arrange_as_array(:order=>"title").each {|n| n.title ="#{'--' * n.depth} #{n.title}" }
  end

  def toggle_disabled
    val = !self.disabled
    self.disabled = val
    self.save
    self.subtree.each do |group|
      group.disabled = val
      group.save
    end
  end

  def set_disabled
    self.subtree.each do |group|
      group.disabled = true
      group.save
    end
  end

  def change_disabled(val)
    disabled = val
    save!
  end

  def set_site_title
    self.site_title = self.title.gsub(/^(\d*\.)/, '').strip
  end

end
