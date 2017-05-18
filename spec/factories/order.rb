FactoryGirl.define do
    factory :order do
        formed nil
        user
        order_list {
                    {"1"=>{"qty"=>1}, "2"=>{"qty"=>1}}
                 }
            factory :formed_order do
                formed Time.now-1.day
            end
    end
end
