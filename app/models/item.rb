class Item < ApplicationRecord
    belongs_to :group
    mount_uploader :image, ImageUploader
    self.per_page = 60
    scope :able, ->{joins(:group).where(:groups => {:disabled => [nil,false]}).select('distinct items.*, groups.site_title as group_title').order("group_id, position")}

    def self.pg_result(properties = false, show_qty = false, price = '0fa9bc8a-166f-11e0-9aa1-001e68eacf93')
        connection = ActiveRecord::Base.connection
        connection.execute(joins("LEFT JOIN currencies ON currencies.name = (items.bids->'#{price}'->>'cy')")
                .joins(:group)
                .where(:groups => {:disabled => [nil,false]})
                .select(QueriesCommands.build_query(properties, show_qty, price)).to_sql)
    end


    
end
