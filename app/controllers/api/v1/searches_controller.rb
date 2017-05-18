class Api::V1::SearchesController < Api::V1Controller
  after_action :set_activity

  def index
    @query_text = params[:q]
    @query = SearchHelper.str_query(params[:q], params[:attr])
    @ids = Item.search_for_ids(@query, set_options)
    @count = Item.search_for_ids(@query, set_options_ids)
    @order = "idx(array#{@ids.to_s}, items.id)::int" if @count.length > 0
    @items = Item.where(:id=>@ids).order("#{@order}").pg_result(false,can_view_qty?,price_type)
    render :json => {:items=>@items, :total_entries=>@count.length, :query_string=>@query_text}
  end

  private

  def set_activity
    activity_save :controller=>"find", :action=>action_name, :text=>@query_text, :result=>@count.length, :page=>params[:page]
  end

  def set_options
    options = {}
    options[:field_weights] = {:kod => 1000, :article => 60, :oem => 5,:full_name => 20}
    options[:order_by] = 'properties["Код товара"]'
    options[:per_page] = 60
    options[:with] = {:group_id => params[:group].to_i} if params[:group]
    options[:page] = params[:page]
    options
  end


  def set_options_ids
    options = set_options
    options[:page] = nil
    options[:per_page] = 1000
    options
  end
    
end
