  class Api::Admin::ActivitiesController < Api::AdminController
    before_action :set_activity, :only=>[:show]

    def index
        @activities = Activity.where.not(user_id: nil).limit(500).order("updated_at DESC")
        render json: @activities
    end


    private

    def set_activity
        @activity = Activity.find(params[:id])
    end
end
