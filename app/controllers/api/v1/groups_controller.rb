class Api::V1::GroupsController < Api::V1Controller
    rescue_from ActiveRecord::RecordNotFound do |exception|
        render json: {success: false, error:'record not found'}, :status => 404 # nothing, redirect or a template
    end
    before_action :set_group, only: [:show]
    after_action :set_activity, only: [:index, :show]

    def index
        @groups = Group.select("site_title as title, id, ancestry, CASE WHEN (extract(epoch from last_new_item)+1209600) > (extract(epoch from now())) THEN true ELSE false END AS new, items_count").all.index_by(&:id)
        @sort = Group.select("ancestry, id, menu_columns").able.arrange_serializable(:order=>:title) do |parent, children|
            h = {id: parent.id}
            if children
                h[:c] = children
            end
            if parent.ancestry == nil
                h[:col] = parent.menu_columns
            end
            h
        end
        render json: {groups:@groups, tree:@sort}
    end

    def show
        query = "items.group_id = #{@group.id}"
        @show_properties = false
        query += " AND items.qty > 0" if params[:only_in_stock] == 'true'
        query += " AND items.created_at > '#{DateTime.now-7.days}'" if params[:only_new] == 'true'
        render json: {  group: @group, 
                        items: Item.where(query).pg_result(false,can_view_qty?,price_type)
                    }
    end
    
    private
    
    def set_group
	  @group = Group.find(params[:id])
	end

    def set_activity
        unless params[:page] 
            activity_save :controller=>controller_name, :action=>action_name, :group=>(@group.site_title if @group), :group_id=>(@group.id if @group), :page=>params[:page]
        end  
    end

end