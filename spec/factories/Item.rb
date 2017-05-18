FactoryGirl.define do
  factory :item do
    article 'art1'
    title 'Tovar1'
    full_title 'Tova1'
    group_cid 'sdsada'
    qty 5
    group_id { rand(10) }
    bids { 
            {   "0fa9bc88-166f-11e0-9aa1-001e68eacf93":
                    {   "cy":"руб",
                        "unit":"шт.",
                        "title":"10 руб. за шт.", 
                        "value":10.0}, 
                "0fa9bc8a-166f-11e0-9aa1-001e68eacf93":
                    {   "cy":"руб", 
                        "unit":"шт.", 
                        "title":"20 руб. за шт.", 
                        "value":20.0}
                    }
             }
    group
  end
end