class ActivityHelper
    class << self
        def activity_save arg
            @activity ={}
            @activity['user_id'] = arg[:user_id].id
            @activity['controller'] = arg[:controller]
            @activity['action'] = arg[:action]
            @activity['log'] = arg.except(:controller,:action, :user_id, :request)
            @activity['ip'] = arg[:request].remote_ip
        end
    end
end