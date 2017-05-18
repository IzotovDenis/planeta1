FactoryGirl.define do
    factory :auth_token do
        val { rand }

        factory :auth_token_retail do
            association :user, factory: :user, role: "retail"
        end

        factory :auth_token_user do
            association :user, factory: :user, role: "user"
        end

        factory :auth_token_buyer do
            association :user, factory: :user, role: "buyer"
        end
    end
end