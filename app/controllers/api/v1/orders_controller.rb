class Api::V1::OrdersController < Api::V1Controller
    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {success: false, error: e.message }, :status => 404 # nothing, redirect or a template
    end
    before_action :set_order, only: [:add_items, :update, :show, :delete_items, :complete, :select_order]
    after_action :set_activity, only: [:add_items, :delete_items]

    def index
        authorize! :read, Order
        @orders = current_user.orders.completed
        render json: {success: true, orders: @orders}
    end

    def show
        authorize! :read, @order
        render json: {:order=>@order.show_list}
    end

    def select_order
        authorize! :manage, @order
        render json: {order: @order.show_order_list.slice(:id, :amount, :name, :qty), items:@order.order_list}
    end

    def active
       hash = {active: 1, ids: {}, items:{}}
       @orders = current_user.orders.active
       if @orders.empty?
           Order.create(:user => current_user)
           @orders = current_user.orders.active
       end
       @orders.each do |order|
           hash[:active] = order.id
           hash[:ids][order.id] = order.show_order_list.slice(:id, :amount, :name, :qty)
           hash[:items] = order.order_list
       end
       render json: {:orders=> hash}
    end

    def add_items
        authorize! :manage, @order
        ids = items_params
        @items = Item.where("id IN (?)", ids.keys).select("id")
        @old_items = @order.order_list.dup
        @items.each do |item|
            @order.order_list[item.id.to_s] ? date = @order.order_list[item.id.to_s]['created_at'] : date = DateTime.now.to_i
            @order.order_list[item.id] = {'qty'=>ids[item.id.to_s].to_i, 'created_at'=>date}
        end
        if @order.save
            if params[:fullOrder] == 'true'
                response = {:order=>@order.show_list}
            else
                response = {success: true, order: @order.show_order_list.slice(:id,:name,:amount, :qty), items:@order.order_list}
            end
            render :json => response
        end
        @new_items = @order.order_list.dup
    end

    def create
        authorize! :create, Order
        @order = Order.new(:user=>current_user, :name=>params[:order][:name])
        if @order.save
            render json: {:order=>@order.show_order_list.slice(:id, :name, :amount, :qty), :items=>{}, :success=>true}
        else
            render json: {:success=>false}
        end
    end

    def complete
        authorize! :manage, @order
        if @order.has_items?
            @order.comment = params[:comment]
            if @order.complete
                render :json => {status: "success", order: @order}
            end 
        else
            render :json => {status: "error"}
        end
    end

    def delete_items
        authorize! :manage, @order
        @old_items = @order.order_list.dup
        ids = params[:items]
        ids.each do |id|
            @order.order_list.delete(id)
        end
        if @order.save
            if params[:fullOrder] == 'true'
                response = {:order=>@order.show_list}
            else
                response = {success: true, order: @order.show_order_list.slice(:id,:name,:amount, :qty), items:@order.order_list}
            end
            render :json => response
        end
        @new_items = @order.order_list.dup
    end


    private

    def set_order
        @order = Order.find(params[:id])
    end

    def order_params
        unless ['create', 'show', 'delete_items'].include? action_name
            params.require(:order).permit(:id)
        end 
    end

    def items_params
        params.require(:items).permit!
    end
    
    def set_activity
        activity_save :controller=>controller_name, :action=>action_name,  :old_items=>@old_items, :new_items=>@new_items, :path=>URI(request.referer).path
    end
end
