class Api::V1Controller < ApiController
  include CanCan::ControllerAdditions
  rescue_from CanCan::AccessDenied do |e|
    render :json=>{success: false, error: e.message}, :status => 403
  end


    def current_user
        @current_user ||= AuthCommands.current_user(params[:token])
    end

    def can_view_qty_checker?
        if can? :view, :qty
            return true
        else
            return false
        end
    end

    def can_view_qty?
        @can_view_qty ||= can_view_qty_checker?
    end

    def price_type
        if current_user
            current_user.price_type
        else
            User.new.price_type
        end
    end

    def activity_save arg
        puts "================="
        current_user ? user_id = current_user.id : user_id = nil
        @activity ={}
        @activity['user_id'] = user_id
        @activity['controller'] = arg[:controller]
        @activity['action'] = arg[:action]
        @activity['log'] = arg.except(:controller, :action)
        @activity['ip'] = request.remote_ip
        puts @activity.inspect
        puts "================="
        ActivityWorker.perform_async(@activity)
    end

end
