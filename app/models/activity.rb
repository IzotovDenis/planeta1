class Activity < ActiveRecord::Base
	belongs_to :user, :counter_cache => true
	after_save :set_activity_to_user
	scope :today, ->{where(:created_at=>DateTime.now.beginning_of_day..DateTime.now.end_of_day)}
	scope :yesterday, ->{where(:created_at=>DateTime.now.beginning_of_day-1.day..DateTime.now.end_of_day-1.day)}

	def set_activity_to_user
		User.where("id = ?",self.user_id).update_all(:last_activity_at=>self.updated_at)
	end
	

	def self.add_items_to_order(hash)
		new_items = hash['log']['new_items'].dup
		old_items = hash['log']['old_items'].dup
		new_items.keys.each do |key|
			if old_items[key]
				if old_items[key]['qty'] != new_items[key]['qty']
					Activity.add_item_to_order(hash, key, new_items[key]['qty'],'update')
				end
			else
				Activity.add_item_to_order(hash, key, new_items[key]['qty'],'create')
			end
		end
	end

	def self.delete_items_from_order(hash)
		new_items = hash['log']['new_items'].dup
		old_items = hash['log']['old_items'].dup
		new_items.keys.map { |key| old_items.except!(key)}
		old_items.keys.map { |key| Activity.delete_item_from_order(hash, key, old_items[key]['qty'])}
	end

	def self.delete_item_from_order(hash, id, qty)
		hash['log'].delete('old_items')
		hash['log'].delete('new_items')
		@item = Item.where(:id=>id).select('id, full_title').first
		hash['controller'] = 'order_items'
		hash['action'] = 'destroy'
		hash['log']['qty'] = qty
		hash['log']['item_title'] = @item.full_title
		hash['log']['item_id'] = @item.id
		Activity.create!(hash)
	end

	def self.add_item_to_order(hash,id,qty,action)
		hash['log'].delete('old_items')
		hash['log'].delete('new_items')
		@item = Item.where(:id=>id).select('id, full_title').first
		hash['controller'] = 'order_items'
		if action == 'update'
			hash['action'] = 'update'
		else
			hash['action'] = 'create'
		end
		hash['log']['qty'] = qty
		hash['log']['item_title'] = @item.full_title
		hash['log']['item_id'] = @item.id
		Activity.create!(hash)
	end

	def self.add_group(hash)
		puts "-----------"
		puts hash
		puts "-----------"
		Activity.create!(hash)
	end

	def self.add_search(hash)
		@last_activity = Activity.where(:user_id=>hash["user_id"], :controller=>"find").last
		if @last_activity
			@last_query = @last_activity.log["text"].gsub(/[^0-9A-Za-z]/, ' ')
			query = hash["log"]["text"].gsub(/[^0-9A-Za-z]/, ' ')
			regexp = /^(#{@last_query})/
			if regexp.match(query)
				@last_activity.update(hash)
			else
				Activity.create!(hash)
			end
		else
			Activity.create!(hash)
		end
	end

	def self.router(hash)
		puts hash
		if hash["controller"] == "find"
			Activity.add_search(hash)
		elsif hash["controller"] == "orders"
			if hash["action"] == "add_items"
				Activity.add_items_to_order(hash)
			elsif hash["action"] == "delete_items"
				Activity.delete_items_from_order(hash)
			elsif hash["action"] == "forwarding"
				Activity.forwarding(hash)
			end
		elsif hash["controller"] == "groups"
			Activity.add_group(hash)
		end
	end

end
