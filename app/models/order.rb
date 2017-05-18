class Order < ApplicationRecord

	scope :active, ->{where("formed IS NULL").order("formed DESC")}
	scope :completed, ->{joins(:user).select('orders.id, users.name as user_name, orders.user_id, orders.name, orders.total as amount, orders.formed').where("formed IS NOT NULL").order("formed DESC")}	
    belongs_to :user

    def show_list
		@price_type = self.user.price_type
		connection = ActiveRecord::Base.connection
			hash = {}
			hash['id'] = id
			hash['amount'] = total
			hash['date'] =  formed
			hash['comment'] = comment
			hash['name'] = name
			hash['items'] = connection.execute("SELECT
						items.article,
						json_data.key AS id, 
						json_data.value::jsonb->'qty' AS ordered,
						round (CAST (CASE coalesce(orders.formed::text, 'null') WHEN 'null' THEN coalesce((coalesce((items.label->'discount')::float*(items.bids->'#{@price_type}'->>'value')::float, (items.bids->'#{@price_type}'->>'value')::float))*currencies.val, '0.00')::text ELSE CAST(json_data.value::jsonb->'price' AS text) END AS numeric),2) AS price,
						items.full_title as title,
						CASE  WHEN items.qty BETWEEN 0 AND 9 THEN items.qty::text
									WHEN items.qty BETWEEN 10 AND 49 THEN '10-49'::text
									WHEN items.qty BETWEEN 50 AND 100 THEN '50-100'::text
									ELSE '> 100'::text END as item_qty,
						CASE coalesce(items.image, 'null') WHEN 'null' THEN 'false'::boolean ELSE 'true' END AS image,
						items.properties-> 'Код товара' as kod
						FROM orders, jsonb_each_text(orders.order_list) AS json_data
						INNER JOIN items ON items.id = json_data.key::int
						LEFT JOIN currencies ON currencies.name = (items.bids->'#{@price_type}'->>'cy')
						WHERE orders.id=#{id} ORDER BY json_data.value::jsonb->'created_at' DESC")
			if hash['amount'] == 0
				hash['items'].each do |item|
					hash['amount'] += item['ordered'].to_i*item['price'].to_f
				end
			end
		    return hash
	end

	def show_order_list
		connection = ActiveRecord::Base.connection
		@price_type = self.user.price_type
		order = {}
		order[:id] = self.id
		order[:name] = self.name
		order[:amount] = 0
		order[:order_list] = {}
		order[:qty] = self.order_list.keys.count
		self.order_list.keys.each do |key|
			order[:order_list][key] = self.order_list[key]
		end
		items = connection.execute("SELECT
						json_data.key AS id, 
						json_data.value::jsonb->'qty' AS ordered,
						round (CAST (CASE coalesce(orders.formed::text, 'null') WHEN 'null' THEN coalesce((coalesce((items.label->'discount')::float*(items.bids->'#{@price_type}'->>'value')::float, (items.bids->'#{@price_type}'->>'value')::float))*currencies.val, '0.00')::text ELSE CAST(json_data.value::jsonb->'price' AS text) END AS numeric),2) AS price
						FROM orders, jsonb_each_text(orders.order_list) AS json_data
						INNER JOIN items ON items.id = json_data.key::int
						LEFT JOIN currencies ON currencies.name = (items.bids->'#{@price_type}'->>'cy')
						WHERE orders.id=#{id}")
		items.each do |item|
			order[:amount] += item['ordered'].to_i*item['price'].to_f
		end
		order
	end

	def complete
		self.formed = Time.now if !self.formed
		@items = self.show_list['items']
		total = 0
			@items.each do |item|
				self.order_list[item['id']]['price'] = item['price'].to_f
				total += item['price'].to_f.round(2) * item['ordered'].to_i
			end
		self.total = total
		self.save!
	end

	def has_items?
		self.order_list.keys.count >=1
	end

end
