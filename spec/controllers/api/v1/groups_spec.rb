#encoding: utf-8

require 'rails_helper'
describe "Group API", type: :request do
    before(:all) do
      puts "group"
    FactoryGirl.create(:currency)
    @group = FactoryGirl.create(:group)
    [20,0,5].each do |qty|
      FactoryGirl.create(:item, group: @group, qty: qty)
    end
    @buyer = FactoryGirl.create(:auth_token_buyer)
    @user = FactoryGirl.create(:auth_token)
    end

  it 'sends a list of Groups' do

    get '/api/v1/groups'

    json = JSON.parse(response.body)

    expect(json['groups'].length).to eq(1)
  end
  
  it 'retrieves a specific message' do
    get "/api/v1/groups/#{@group.id}"

    # test for the 200 status-code
    expect(response).to be_success

  end

  it 'Price should be retail for not auth users' do
    get "/api/v1/groups/#{@group.id}"
    expect(json['items'].first['price']).to eq(20.0)
    expect(json['items'].length).to eq(3)
    expect(response).to be_success
  end

  it 'Price should be retail for users with role user ' do
    get "/api/v1/groups/#{@group.id}?auth_token=#{@user.val}", params: nil
    expect(json['items'].first['price']).to eq(20.0)
  end


  it 'Price should be buyer for users with role buyer' do
    get "/api/v1/groups/#{@group.id}?auth_token=#{@buyer.val}", params: nil
    expect(json['items'].first['price']).to eq(10.0)
  end

  it 'Qty should be visible for users with role buyer' do
    get "/api/v1/groups/#{@group.id}?auth_token=#{@buyer.val}", params: nil
    expect(json['items'].first['qty']).to eq("5")
  end

  it 'Qty should be not visible for users with role user' do
    get "/api/v1/groups/#{@group.id}?auth_token=#{@user.val}", params: nil
    expect(json['items'].first['qty']).to eq('in_stock')
  end

  it 'Qty should be not visible for users with role user' do
    get "/api/v1/groups/#{@group.id}?auth_token=#{@user.val}", params: nil
    expect(json['items'][1]['qty']).to eq('out_of_stock')
  end


end