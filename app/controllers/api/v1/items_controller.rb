class Api::V1::ItemsController < Api::V1Controller
    rescue_from ActiveRecord::RecordNotFound do |exception|
        render json: {success: false, error:'record not found'}, :status => 404 # nothing, redirect or a template
    end
    before_action :set_properties, only: [:show]
    before_action :set_item, only: [:show]

    def show
        render json: {
                        item: @item
                    }
    end
    
    private

    def set_properties
        if params[:prop] == "1"
            @properties = true
        else
            @properties = false
        end
    end
    
    def set_item
        @item = Item.where("properties -> 'Код товара' = :value", :value=>params[:id]).pg_result(@properties,can_view_qty?,price_type).first
    end
end