class Api::V1::UsersController < Api::V1Controller

    def index
        render json: current_user
    end

    def show
        if current_user
            if can? :create, Order 
                puts "CAN ORDER"
            else
                puts "CANNOT ORDER"
            end
            render json: {auth: true, user: current_user, can_order: (can? :create, Order) }
        else
            render json: {auth: false, user: {}}
        end
    end

    def sign_in
        user = User.find_for_authentication(:email=>params[:user][:email])
        if user
            if user.valid_password?(params[:user][:password])
                token = AuthCommands.generate_token(user.id)
                render json: {success: true, token: token.val, user: user} 
            else
                render json: false
            end
        else   
            render json: {success: false, error: 'User not fount'}
        end
    end

    def sign_up
        @user = User.new(user_params)
        if @user.save
            token = AuthCommands.generate_token(@user.id)
            render json: {success: true, token: token.val, user: @user} 
        else
            render json: {errors: @user.errors, success: false}
        end
    end

private

    def user_params
     params.require(:user).permit(  :email,
                                    :name,
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
                                    :curr_account,
                                    :kpp, 
                                    :inn, 
                                    :note, 
                                    :person,
                                    :password,
                                    :password_confirmation)
    end
    
end
