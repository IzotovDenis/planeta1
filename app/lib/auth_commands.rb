class AuthCommands
    class << self
        require 'digest'
        def current_user(header)
            db_token = AuthToken.where(:val=>header).first
            if db_token 
                return db_token.user
            else
                return nil
            end
        end

        def generate_token(user_id)
            @token = Digest::SHA256.hexdigest("#{user_id} #{DateTime.now}")
            auth_token = AuthToken.create(:user_id=>user_id, :val => @token)
            return auth_token
        end
    end
end