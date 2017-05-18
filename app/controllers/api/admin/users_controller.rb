class Api::Admin::UsersController < Api::AdminController
    before_action :set_user, :only=>[:show, :update, :update_role]

    def index
        @users = User.all
        render json: @users
    end
    

    def show
        render json: @user
    end

    def update
        if @user.update(user_params)
            render json: @user
        else
            render json: {error: true}
        end
    end

    def update_role
        if @user.update(:role=>user_params[:role])
            render json: @user
        else  
            render json: {error: true}
        end
    end


    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
     params.require(:user).permit(:name,
                                    :city,
                                    :name, 
                                    :phone, 
                                    :bik, 
                                    :curr_address, 
                                    :legal_address,
                                    :actual_address, 
                                    :bik, 
                                    :bank_name, 
                                    :corr_account, 
                                    :curr_account ,
                                    :kpp, 
                                    :inn, 
                                    :note, 
                                    :person,
                                    :role)
    end
end
