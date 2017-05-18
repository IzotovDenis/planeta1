#encoding: utf-8

require 'rails_helper'
describe "Order API", type: :request do
	before(:all) do
		puts 'FIrst'
		puts Item.count
		@group = FactoryGirl.create(:group)
		@items_ids = []
		[20,0,5].each do |qty|
		item = FactoryGirl.create(:item, group: @group, qty: qty)
		@items_ids.push(item.id)
		end
		@order_list = Hash[@items_ids.collect { |i| [i,{"qty":1}]}]
		@buyer = FactoryGirl.create(:auth_token_buyer)
		@buyer2 = FactoryGirl.create(:auth_token_buyer)
		@user = FactoryGirl.create(:auth_token_user)
		@user_order = FactoryGirl.create(:order, user: @user.user, order_list: @order_list )
		@buyer_order = FactoryGirl.create(:order, user: @buyer.user, order_list: @order_list)
		@buyer2_order = FactoryGirl.create(:order, user: @buyer2.user, order_list: @order_list)
		FactoryGirl.create_list(:order,4, user: @buyer.user)
		FactoryGirl.create_list(:order,2, user: @buyer2.user)
		@formed_order = FactoryGirl.create(:formed_order, user: @buyer.user)
	end
 
  it 'Buyer can create order' do
		post "/api/v1/orders?auth_token=#{@buyer.val}", params: {"order": {'id': 'new'} }
		expect(json['success']).to eq(true)
  end

  it 'Buyer can see active orders' do
		get "/api/v1/orders/active?auth_token=#{@buyer.val}", params: nil
		expect(json['orders'].length).to eq(5)
  end

  it 'Buyer can see active orders' do
		get "/api/v1/orders/active?auth_token=#{@buyer.val}", params: nil
		expect(json['orders'].length).to eq(5)
  end

	it 'User cannot create order' do
			post "/api/v1/orders/?auth_token=#{@user.val}", params: nil
			expect(json['success']).to eq(false)
	end

	it 'User cannot create order' do
		post "/api/v1/orders/?auth_token=#{@user.val}", params: {"order":nil}
		expect(json['success']).to eq(false)
	end

	it 'Buyer can add item to order' do
		post "/api/v1/orders/#{@buyer_order.id}/add_items?auth_token=#{@buyer.val}", params: {"items":{"#{@items_ids[0]}":"1"}}
		expect(response.status).to eq(200)
	end

	it 'Buyer can add item to Buyer2 order' do
		post "/api/v1/orders/#{@buyer2_order.id}/add_items?auth_token=#{@buyer.val}", params: {"items":{"#{@items_ids[0]}":"1"}}
		expect(response.status).to eq(403)
	end

	it 'User cannot add item to order' do
		post "/api/v1/orders/#{@buyer_order.id}/add_items?auth_token=#{@user.val}", params: {"items":{"#{@items_ids[0]}":"1"}}
		expect(response.status).to eq(403)
	end

	it 'User can see own order' do
		get "/api/v1/orders/#{@buyer_order.id}?auth_token=#{@buyer.val}", params: nil
		expect(response.status).to eq(200)
		expect(json['order']['id']).to eq(@buyer_order.id)
	end

	it 'User can not see other users orders' do
		get "/api/v1/orders/#{@buyer_order.id}?auth_token=#{@user.val}", params: nil
		expect(response.status).to eq(403)
	end

	it 'Buyer can not see other users orders' do
		get "/api/v1/orders/#{@buyer2_order.id}?auth_token=#{@buyer.val}", params: nil
		expect(response.status).to eq(403)
	end

	it 'Buyer can forward buyer_order' do
		post "/api/v1/orders/#{@buyer_order.id}/complete?auth_token=#{@buyer.val}", params: nil
		expect(response.status).to eq(200)
	end

	it 'Buyer2 cannot forward buyer_order' do
		post "/api/v1/orders/#{@buyer_order.id}/complete?auth_token=#{@buyer2.val}", params: nil
		expect(response.status).to eq(403)
	end

	it 'User cannot forward user_order' do
		post "/api/v1/orders/#{@user_order.id}/complete?auth_token=#{@user.val}", params: nil
		expect(response.status).to eq(403)
	end

	it 'It buyer can delete item from buyer_order' do
		post "/api/v1/orders/#{@buyer_order.id}/delete_items?auth_token=#{@buyer.val}", params: {"items":["#{@items_ids[0]}"]} 
		expect(response.status).to eq(200)
		expect(json['order']['items'].length).to eq(@items_ids.length-1)
	end

	it 'buyer cannot delete item from buyer2_order' do
		post "/api/v1/orders/#{@buyer2_order.id}/delete_items?auth_token=#{@buyer.val}", params: {"items":["#{@items_ids[0]}"]} 
		expect(response.status).to eq(403)
	end

	it 'user cannot delete item from buyer2_order' do
		post "/api/v1/orders/#{@buyer2_order.id}/delete_items?auth_token=#{@user.val}", params: {"items":["#{@items_ids[0]}"]} 
		expect(response.status).to eq(403)
	end

end