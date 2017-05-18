class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    has_many :auth_tokens
    has_many :orders
    has_secure_password

    def price_type
        if role == 'buyer'
            return '0fa9bc88-166f-11e0-9aa1-001e68eacf93'
        end
        if role == 'user'
            return '0fa9bc8a-166f-11e0-9aa1-001e68eacf93'
        end
    end

end
