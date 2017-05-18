class Api::Admin::OrdersController < Api::AdminController
    before_action :set_order, :only=>[:show]

    def index
        if params[:user_id]
            @orders = Order.completed
        else
            if params[:from]
                @start = (DateTime.strptime(params[:from], "%Q")+10.hours).beginning_of_day
                puts (DateTime.strptime(params[:from], "%Q")+10.hours)
            else
                @start = DateTime.now().beginning_of_day
            end
            @end = @start + 1.day
            @orders = Order.completed.where(:formed=>@start..@end).order('formed DESC')
        end
        puts @start
        puts @end
        render json: {orders: @orders.select(:id, :user_id, :name, :total, :formed)}
    end
    

    def show
        render json: @order.show_list
    end


    private

    def set_order
        @order = Order.find(params[:id])
    end
end
